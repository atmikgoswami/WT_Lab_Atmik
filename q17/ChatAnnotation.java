package WT_Lab_Atmik.q17;

import java.io.IOException;
import java.util.ArrayDeque;
import java.util.Queue;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.atomic.AtomicInteger;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.apache.juli.logging.Log;
import org.apache.juli.logging.LogFactory;

import WT_Lab_Atmik.q17.util.HTMLFilter;

@ServerEndpoint(value = "/WT_Lab_Atmik/q17")
public class ChatAnnotation {

    private static final Log log = LogFactory.getLog(ChatAnnotation.class);

    private static final String GUEST_PREFIX = "Guest";
    private static final AtomicInteger connectionIds = new AtomicInteger(0);
    private static final Set<ChatAnnotation> connections = new CopyOnWriteArraySet<>();
    private static final Set<String> activeNicknames = new CopyOnWriteArraySet<>();

    private final String nickname;
    private Session session;
    private Queue<String> messageBacklog = new ArrayDeque<>();
    private boolean messageInProgress = false;

    public ChatAnnotation() {
        nickname = GUEST_PREFIX + connectionIds.getAndIncrement();
    }

    @OnOpen
    public void start(Session session) {
        this.session = session;
        connections.add(this);
        activeNicknames.add(nickname);  
        String message = String.format("* %s %s", nickname, "has joined.");
        broadcast(message);
    }

    @OnClose
    public void end() {
        connections.remove(this);
        activeNicknames.remove(nickname);  
        String message = String.format("* %s %s", nickname, "has disconnected.");
        broadcast(message);
    }

    @OnMessage
    public void incoming(String message) {
        if (message.startsWith("To:")) {
            String[] parts = message.split(" ", 2);
            if (parts.length > 1) {
                String recipientNickname = parts[0].substring(3);  
                String privateMessage = parts[1];
                sendPrivateMessage(recipientNickname, privateMessage);
            }
        } else {
            String filteredMessage = String.format("%s: %s", nickname, HTMLFilter.filter(message));
            broadcast(filteredMessage);
        }
    }

    @OnError
    public void onError(Throwable t) throws Throwable {
        log.error("Chat Error: " + t.toString(), t);
    }

    private void sendMessage(String msg) throws IOException {
        synchronized (this) {
            if (messageInProgress) {
                messageBacklog.add(msg);
                return;
            } else {
                messageInProgress = true;
            }
        }

        boolean queueHasMessagesToBeSent = true;

        String messageToSend = msg;
        do {
            session.getBasicRemote().sendText(messageToSend);
            synchronized (this) {
                messageToSend = messageBacklog.poll();
                if (messageToSend == null) {
                    messageInProgress = false;
                    queueHasMessagesToBeSent = false;
                }
            }

        } while (queueHasMessagesToBeSent);
    }

    private void sendPrivateMessage(String recipientNickname, String message) {
        for (ChatAnnotation client : connections) {
            if (client.nickname.equals(recipientNickname)) {
                try {
                    String privateMessage = String.format("Private from %s: %s", nickname, message);
                    client.sendMessage(privateMessage);
                    this.sendMessage(String.format("Private to %s: %s", recipientNickname, message));
                    return;
                } catch (IOException e) {
                    log.error("Failed to send private message", e);
                }
            }
        }
        try {
            this.sendMessage(String.format("User %s not found", recipientNickname));
        } catch (IOException e) {
            log.error("Failed to send error message", e);
        }
    }

    private static void broadcast(String msg) {
        for (ChatAnnotation client : connections) {
            try {
                client.sendMessage(msg);
            } catch (IOException e) {
                log.debug("Chat Error: Failed to send message to client", e);
                if (connections.remove(client)) {
                    try {
                        client.session.close();
                    } catch (IOException e1) {
                    }
                    String message = String.format("* %s %s", client.nickname, "has been disconnected.");
                    broadcast(message);
                }
            }
        }
    }
}