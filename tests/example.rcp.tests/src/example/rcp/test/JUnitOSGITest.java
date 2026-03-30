package example.rcp.test;

import static org.junit.Assert.*;

import org.junit.Test;
import org.osgi.framework.FrameworkUtil;

public class JUnitOSGITest {

	@Test
	public void test() {
		assertNotNull(FrameworkUtil.getBundle(this.getClass()));
	}

}
