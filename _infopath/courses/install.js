objIPExtApp = new ActiveXObject("InfoPath.ExternalApplication");
objIPExtApp.RegisterSolution("S:\\_infopath\\courses\\courses.xsn");
objIPExtApp.Quit();
objIPExtApp = null;