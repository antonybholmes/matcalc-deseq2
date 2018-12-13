package edu.columbia.rdf.matcalc.toolbox.deseq2.app;

import java.awt.FontFormatException;
import java.io.IOException;

import javax.swing.UnsupportedLookAndFeelException;
import javax.xml.parsers.ParserConfigurationException;

import org.jebtk.core.AppService;
import org.jebtk.modern.ColorTheme;
import org.jebtk.modern.theme.ThemeService;
import org.xml.sax.SAXException;

import edu.columbia.rdf.matcalc.MainMatCalc;
import edu.columbia.rdf.matcalc.BasicModuleLoader;
import edu.columbia.rdf.matcalc.bio.BioModuleLoader;
import edu.columbia.rdf.matcalc.toolbox.deseq2.Deseq2Module;

public class MainDeseq2 {
  // private static final Logger LOG =
  // LoggerFactory.getLogger(MainSeqLogo.class);

  public static final void main(String[] args) throws FontFormatException,
      IOException, SAXException, ParserConfigurationException,
      ClassNotFoundException, InstantiationException, IllegalAccessException,
      UnsupportedLookAndFeelException {
    AppService.getInstance().setAppInfo("deseq2");

    ThemeService.getInstance().setTheme(ColorTheme.BLUE);

    BasicModuleLoader ml = new BioModuleLoader();

    ml.addModule(Deseq2Module.class);

    MainMatCalc.main(new Deseq2Info(), ml);
  }
}
