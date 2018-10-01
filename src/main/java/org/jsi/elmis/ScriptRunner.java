package org.jsi.elmis;

import javafx.application.Platform;
import javafx.scene.control.ProgressIndicator;
import javafx.scene.control.TextArea;

import javax.swing.*;
import java.io.*;
import java.nio.charset.Charset;

public class ScriptRunner implements Runnable {

    private static String OS = System.getProperty("os.name");
    private ProgressIndicator progressIndicator;
    private String tempScriptsDirectoryPath;
    private String[] fileNames = new String[]{
            "01_insert_prod_conv_rates.sql",
            "02_backup.sql",
            "03_convert.sql",
            "linux.sh",
            "windows.bat"
    };

    public ScriptRunner(ProgressIndicator progressIndicator){
        this.progressIndicator = progressIndicator;
    }

    @Override
    public void run() {
        System.out.println(OS);
        try {
            if(OS.toLowerCase().contains("windows")){
                this.runCommand("cmd", "/c", "windows.bat");
            }else{
                this.runCommand("/bin/bash", "-c", "linux.sh");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private ProcessBuilder getProcessBuilder(String... commandString) throws IOException{
        ProcessBuilder builder = new ProcessBuilder().command(commandString);
        String userDir = System.getProperty("user.dir");
        tempScriptsDirectoryPath = userDir + "\\scripts";
        File scriptsDir = new File(tempScriptsDirectoryPath);
        if(!scriptsDir.exists()) {
            scriptsDir.mkdir();
        }
        InputStream inputStream = null;
        for(String fileName:fileNames){
            inputStream = getClass().getResourceAsStream("/scripts/" + fileName);
            copyFile(inputStream, new File(scriptsDir + "\\" + fileName));
        }
        builder.directory(scriptsDir);
        return builder;
    }

    void runCommand(String... commandString) throws IOException {
        InputStream is = getProcessBuilder(commandString).start().getInputStream();
        BufferedReader br = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));
        String line;
        while((line = br.readLine()) != null){
            System.out.println(line);
            if(line.equalsIgnoreCase("end")) {
                this.progressIndicator.setVisible(false);
                JOptionPane.showMessageDialog(null, "Script completed successfully!");
                File tempScriptsDirectory = new File(tempScriptsDirectoryPath);
                if (tempScriptsDirectory.exists()) {
                    for (File file : tempScriptsDirectory.listFiles()) {
                        file.delete();
                    }
                    tempScriptsDirectory.delete();
                }
                System.exit(0);
            }
        }
    }


    private void copyFile(InputStream input, File dest)
            throws IOException {
        OutputStream output = null;
        try {
            output = new FileOutputStream(dest);
            byte[] buf = new byte[1024];
            int bytesRead;
            while ((bytesRead = input.read(buf)) > 0) {
                output.write(buf, 0, bytesRead);
            }
        } finally {
            input.close();
            output.close();
        }
    }


}
