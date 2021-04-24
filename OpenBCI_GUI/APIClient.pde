import websockets.*;
import processing.core.PApplet;
import com.google.gson.Gson;

public class APIClient {

    WebsocketServer ws;

    APIClient() {
    }

    public void disconnect() {
        ws = null;
    }

    public void sendMessage(BrainSignal signal) {
        if (signal == null || ws == null) return;

        Gson gson = new Gson();

        ws.sendMessage(gson.toJson(signal));
    }

    public void initialize(PApplet context) {
        ws = new WebsocketServer(context, 8080, "/connect");
    }

    public void uninitialize() {
        this.disconnect();
    }

    public void update() {
        saveNewData();
    }

    
    private void saveNewData() {
        double[][] newData = currentBoard.getFrameData();

        if (newData == null || ws == null) return;

        BrainSignal signal = new BrainSignal(newData);

        sendMessage(signal);
    }


    public void onStartStreaming() {
        
    }

    public void onStopStreaming() {
    }
}

public class BrainSignal {

    double[] channel1;
    double[] channel2;
    double[] channel3;
    double[] channel4;
    double[] channel5;
    double[] channel6;
    double[] channel7;
    double[] channel8;

    BrainSignal(double[][] values) {
        for (int i = 0; i < values.length; i++) {
            switch (i) {
                case 0:
                    this.channel1 = values[i];
                    break;

                case 1:
                    this.channel2 = values[i];  
                    break;

                case 2:
                    this.channel3 = values[i];
                    break;

                case 3:
                    this.channel4 = values[i];  
                    break;

                case 4:
                    this.channel5 = values[i];
                    break;

                case 5:
                    this.channel6 = values[i];
                    break;

                case 6:
                    this.channel7 = values[i];  
                    break;
                case 7:

                    this.channel8 = values[i];
                    break;
            
                default:
                    break;
            }
        }
    }
}
