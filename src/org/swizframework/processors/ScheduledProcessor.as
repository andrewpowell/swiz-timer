package org.swizframework.processors {
import flash.events.TimerEvent;
import flash.utils.Dictionary;
import flash.utils.Timer;

import org.swizframework.core.Bean;
import org.swizframework.events.TimerManagementEvent;
import org.swizframework.metadata.ScheduledMetadataTag;
import org.swizframework.reflection.IMetadataTag;

public class ScheduledProcessor extends BaseMetadataProcessor {

    public var timers:Dictionary = new Dictionary();
    private var _isSetup:Boolean = false;

    public function ScheduledProcessor() {
        super(["Scheduled"], ScheduledMetadataTag);
    }

    protected function setup():void {
        swiz.dispatcher.addEventListener(TimerManagementEvent.RESTART_TIMER, onTimerRestart);
        swiz.dispatcher.addEventListener(TimerManagementEvent.STOP_TIMER, onTimerStop);
        this._isSetup = true;
    }

    /**
     * Executed when a new [Scheduled] metadata tag is found
     */
    override public function setUpMetadataTag(metadataTag:IMetadataTag, bean:Bean):void {
        var scheduled:ScheduledMetadataTag = ScheduledMetadataTag(metadataTag);
        var method:Function = bean.source[ metadataTag.host.name ] as Function;

        setupTimer(scheduled, method);

        if (!this._isSetup)
            setup();

    }

    /**
     * Executed when a [Scheduled] metadata tag has been removed
     */
    override public function tearDownMetadataTag(metadataTag:IMetadataTag, bean:Bean):void {
        var scheduled:ScheduledMetadataTag = ScheduledMetadataTag(metadataTag);
        var method:Function = bean.source[ metadataTag.host.name ] as Function;

        removeTimer(scheduled, method);

    }

    protected function setupTimer(scheduled:ScheduledMetadataTag, method:Function):void {
        var timer:Timer = new Timer(scheduled.delay, scheduled.repeatCount);
        var timerMetadata:TimerMetadata = new TimerMetadata();
        timer.addEventListener(TimerEvent.TIMER, handleTimer);
        timer.start();
        timerMetadata.callback = method;
        timerMetadata.tag = scheduled;
        timerMetadata.timer = timer;
        this.timers[scheduled.host.name] = timerMetadata;
    }

    protected function removeTimer(scheduled:ScheduledMetadataTag, method:Function):void {
        for each (var o:TimerMetadata in timers) {
            if (scheduled.host.name == o.tag.name) {
                if (o.timer.currentCount == o.tag.repeatCount) {
                    stopAndRemoveTimer(o);
                }
                break;
            }
        }
    }

    protected function handleTimer(event:TimerEvent):void {
        var timer:Timer = event.target as Timer;

        for each (var o:TimerMetadata in timers) {
            if (timer == o.timer) {
                if (timer.currentCount == o.tag.repeatCount) {
                    stopAndRemoveTimer(o);
                }
				else
				{
					timer.delay = o.tag.delay;
					timer.repeatCount = o.tag.repeatCount;
				}

                var f:Function = o.callback as Function;
                f.call();
                break;
            }
        }
    }

    protected function onTimerRestart(event:TimerManagementEvent):void {

        for each (var o:TimerMetadata in timers) {
            if (event.functionName == o.tag.host.name) {
                o.timer.reset();
                break;
            }
        }

    }

    protected function onTimerStop(event:TimerManagementEvent):void {

        for each (var o:TimerMetadata in timers) {
            if (event.functionName == o.tag.host.name) {
                o.timer.stop();
                break;
            }
        }

    }

    private function stopAndRemoveTimer(timerMetadata:TimerMetadata):void {
        timerMetadata.timer.stop();
        timerMetadata.timer.removeEventListener(TimerEvent.TIMER, handleTimer);
        timerMetadata.timer = null;
        delete timers[timerMetadata.tag.host.name];
    }


}
}

import flash.utils.Timer;

import org.swizframework.metadata.ScheduledMetadataTag;

class TimerMetadata {

    public var tag:ScheduledMetadataTag;
    public var timer:Timer;
    public var callback:Function;

}