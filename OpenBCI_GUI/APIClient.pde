import websockets.*;
import processing.core.PApplet;
import com.google.gson.Gson;

public class APIClient {

    Gson gson = new Gson();
    WebsocketServer ws;

    APIClient() {
    }

    public void disconnect() {
        ws = null;
    }

    public void sendMessage(BrainSignalRawData signal) {
        if (signal == null || ws == null) return;


        ws.sendMessage(gson.toJson(signal));
    }

    public void initialize(PApplet context) {
        ws = new WebsocketServer(context, 8080, "/connect");
    }

    public void uninitialize() {
        this.disconnect();
    }

    int numSeconds = 5;
    int nPoints;

    private int nPointsBasedOnDataSource() {
        return numSeconds * currentBoard.getSampleRate();
    }

    public void update() {
        // saveNewData();

        if (dataProcessing == null) return;

        //Reusable variables
        String fmt; float val;

        //update the voltage values
        // val = dataProcessing.data_std_uV[channelIndex];
        nPoints = nPointsBasedOnDataSource();
        ArrayList<Float> data = new ArrayList<Float>();

        for(int channelIndex = 0; channelIndex < 8; channelIndex++) {
            // float value = dataProcessing.data_std_uV[i];

            if (dataProcessingFilteredBuffer[channelIndex].length >= nPoints) {
                for (int i = dataProcessingFilteredBuffer[channelIndex].length - nPoints; i < dataProcessingFilteredBuffer[channelIndex].length; i++) {
                    // float time = -(float)numSeconds + (float)(i-(dataProcessingFilteredBuffer[channelIndex].length-nPoints))*timeBetweenPoints;
                    float filt_uV_value = dataProcessingFilteredBuffer[channelIndex][i];

                    data.add(filt_uV_value);
                }
            }
        }

        TimeSeriesRequest request = new TimeSeriesRequest(data);
        request.numPoints = nPoints;

        ws.sendMessage(gson.toJson(request));


    }

    
    private void saveNewData() {
        double[][] newData = currentBoard.getFrameData();

        if (newData == null || ws == null) return;

        BrainSignalRawData signal = new BrainSignalRawData(newData);

        sendMessage(signal);
    }


    public void onStartStreaming() {
        
    }

    public void onStopStreaming() {
    }
}

public class BrainSignalRawData {

    double[] channel1;
    double[] channel2;
    double[] channel3;
    double[] channel4;
    double[] channel5;
    double[] channel6;
    double[] channel7;
    double[] channel8;

    BrainSignalRawData(double[][] values) {
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

public class TimeSeriesRequest {

    float channel1;
    float channel2;
    float channel3;
    float channel4;
    float channel5;
    float channel6;
    float channel7;
    float channel8;
    ArrayList<Float> values;
    public int numPoints;

    TimeSeriesRequest(ArrayList<Float> values) {
        this.values = values;
        for (int i = 0; i < values.size(); i++) {
            switch (i) {
                case 0:
                    this.channel1 = values.get(i);
                    break;

                case 1:
                    this.channel2 = values.get(i);  
                    break;

                case 2:
                    this.channel3 = values.get(i);
                    break;

                case 3:
                    this.channel4 = values.get(i);  
                    break;

                case 4:
                    this.channel5 = values.get(i);
                    break;

                case 5:
                    this.channel6 = values.get(i);
                    break;

                case 6:
                    this.channel7 = values.get(i);  
                    break;
                case 7:

                    this.channel8 = values.get(i);
                    break;
            
                default:
                    break;
            }
        }
    }
}
