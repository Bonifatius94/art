package ui;

import data.entities.AccessPattern;
import data.entities.Configuration;
import data.entities.CriticalAccessQuery;
import data.entities.SapConfiguration;
import data.entities.Whitelist;

import io.msoffice.excel.AccessPatternImportHelper;
import io.msoffice.excel.WhitelistImportHelper;

import java.util.List;

import javafx.application.Application;
import javafx.stage.Stage;

import sap.SapConnector;

public class App extends Application {

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) throws Exception {
        // init global exception handling
        Thread.currentThread().setUncaughtExceptionHandler(this::unhandledExceptionOccurred);

        // test sap queries
        testSapStuff();
    }

    private void unhandledExceptionOccurred(Thread thread, Throwable e) {

        // write thread id and exception to console log
        System.out.println("Thread ID: " + thread.getId());
        System.out.println("Stack Trace:");
        System.out.println(e.getMessage());
    }

    /**
     * Testing Sap Stuff.
     */
    public void testSapStuff() {

        // init user credentials
        String username = "GROUP_11";
        String password = "Wir sind das beste Team!";

        // init sap settings (here: test server data)
        SapConfiguration sapConfig = new SapConfiguration();
        sapConfig.setServerDestination("ec2-54-209-137-85.compute-1.amazonaws.com");
        sapConfig.setSysNr("00");
        sapConfig.setClient("001");
        sapConfig.setLanguage("EN");
        sapConfig.setPoolCapacity("0");

        try {

            List<AccessPattern> patterns = new AccessPatternImportHelper().importAuthorizationPattern("Example - Zugriffsmuster.xlsx");
            patterns.forEach(x -> System.out.println(x));

            Whitelist whitelist = new WhitelistImportHelper().importWhitelist("Example - Whitelist.xlsx");
            whitelist.getEntries().forEach(x -> System.out.println(x));

            // init a new config with the whitelist and access patterns
            Configuration config = new Configuration();
            config.setWhitelist(whitelist);
            config.setPatterns(patterns);

            SapConnector connector = new SapConnector(sapConfig, username, password);
            CriticalAccessQuery result = connector.runAnalysis(config);
            result.getEntries().forEach(x -> System.out.println(x));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Expected results:
     * =================
     * ViolatedUseCaseID: 1.A, UserName: ZT2112_F
     * ViolatedUseCaseID: 1.A, UserName: ZT2113_1_P
     * ViolatedUseCaseID: 1.A, UserName: ZT3222_1_P
     * ViolatedUseCaseID: 1.A, UserName: ZT3223_1_P
     * ViolatedUseCaseID: 1.A, UserName: ZT3223_F
     * ViolatedUseCaseID: 1.A, UserName: ZT3224_1_P
     * ViolatedUseCaseID: 1.A, UserName: ZT3224_F
     * ViolatedUseCaseID: 2.A, UserName: ZT1415_P
     * ViolatedUseCaseID: 2.A, UserName: ZT2113_1_P
     * ViolatedUseCaseID: 2.A, UserName: ZT2313_1_P
     * ViolatedUseCaseID: 2.B, UserName: ZT2112_F
     * ViolatedUseCaseID: 2.B, UserName: ZT2113_1_P
     * ViolatedUseCaseID: 2.B, UserName: ZT2113_2_P
     * ViolatedUseCaseID: 2.B, UserName: ZT2211_1_P
     * ViolatedUseCaseID: 2.B, UserName: ZT2211_2_P
     * ViolatedUseCaseID: 2.B, UserName: ZT4212_P
     * ViolatedUseCaseID: 2.B, UserName: ZT2112_F
     * ViolatedUseCaseID: 2.B, UserName: ZT2211_2_P
     * ViolatedUseCaseID: 2.B, UserName: ZT4212_P
     * ViolatedUseCaseID: 2.C, UserName: ZT2112_F
     * ViolatedUseCaseID: 2.C, UserName: ZT2113_1_P
     * ViolatedUseCaseID: 2.C, UserName: ZT2313_1_P
     * ViolatedUseCaseID: 2.C, UserName: ZT2112_F
     * ViolatedUseCaseID: 2.C, UserName: ZT2113_1_P
     * ViolatedUseCaseID: 2.C, UserName: ZT2313_1_P
     * ViolatedUseCaseID: 2.C, UserName: ZT2313_2_P
     * ViolatedUseCaseID: 3.A, UserName: ZT2112_F
     * ViolatedUseCaseID: 3.B, UserName: ZT2111_F
     * ViolatedUseCaseID: 3.B, UserName: ZT2112_P
     * ViolatedUseCaseID: 3.B, UserName: ZT2113_1_F
     *
     */
}