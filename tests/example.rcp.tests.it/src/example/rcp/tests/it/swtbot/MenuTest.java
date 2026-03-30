package example.rcp.tests.it.swtbot;

import static org.eclipse.swtbot.swt.finder.waits.Conditions.shellCloses;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.not;

import org.eclipse.swtbot.swt.finder.SWTBot;
import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner;
import org.eclipse.swtbot.swt.finder.widgets.SWTBotMenu;
import org.eclipse.swtbot.swt.finder.widgets.SWTBotShell;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;

@RunWith(SWTBotJunit4ClassRunner.class)
public class MenuTest {

	private static SWTBot bot;

	@BeforeClass
	public static void beforeClass() throws Exception {
		// don't use SWTWorkbenchBot here which relies on Platform 3.x
		bot = new SWTBot();
	}

	@Test
	public void ensureSaveIsDisabledWhenNothingIsDirty() {
		SWTBotMenu menu = bot.menu("File").menu("Save");
		assertThat("Save command in menu is not enabled", not(menu.isEnabled()));
	}
/*
	@Test
	public void ensureQuitButton() {
		SWTBotMenu menu = bot.menu("File").menu("Quit").click();
		assertThat("Quit command in menu is not enabled", not(menu.isEnabled()));
		SWTBotShell dialog = bot.shell("Confirmation");
		dialog.activate();
		bot.label("Do you want to exit?");
		bot.button("Exit").click();
		bot.waitUntil(shellCloses(dialog));
	}
*/
}
