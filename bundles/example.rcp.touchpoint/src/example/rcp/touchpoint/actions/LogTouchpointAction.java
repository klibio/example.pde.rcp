package example.rcp.touchpoint.actions;

import java.util.Map;

import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.equinox.p2.engine.spi.ProvisioningAction;

public class LogTouchpointAction extends ProvisioningAction {

    @Override
    public IStatus execute(Map<String, Object> parameters) {
        String message = asString(parameters.get("message"));
        if (message == null || message.isBlank()) {
            message = "custom touchpoint action executed";
        }
        System.out.println("[example.rcp.touchpoint.log] " + message);
        return Status.OK_STATUS;
    }

    @Override
    public IStatus undo(Map<String, Object> parameters) {
        return Status.OK_STATUS;
    }

    private String asString(Object value) {
        return value instanceof String ? (String) value : null;
    }
}
