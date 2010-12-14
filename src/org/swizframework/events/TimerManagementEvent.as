package org.swizframework.events {
import flash.events.Event;

public class TimerManagementEvent extends Event	 {

    public static const STOP_TIMER:String = "org.swizframework.events.TimerManagementEvent.STOP_TIMER";
    public static const RESTART_TIMER:String = "org.swizframework.events.TimerManagementEvent.RESTART_TIMER";
    ;

    private var _functionName:String;

    public function TimerManagementEvent(type:String, functionName:String) {
        super(type, true, true);
        this._functionName = functionName;
    }

    public function get functionName():String {
        return _functionName;
    }

    public function set functionName(value:String):void {
        _functionName = value;
    }

    override public function clone():Event {
        return new TimerManagementEvent(this.type, this._functionName);
    }
}
}