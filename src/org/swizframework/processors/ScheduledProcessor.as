package org.swizframework.processors {

    import flash.events.TimerEvent;

    import flash.utils.Dictionary;
    import flash.utils.Timer;

    import org.swizframework.core.Bean;
    import org.swizframework.metadata.ScheduledMetadataTag;
    import org.swizframework.reflection.IMetadataTag;

    public class ScheduledProcessor extends BaseMetadataProcessor {

        private var _timers:Dictionary = new Dictionary();

        public function ScheduledProcessor() {
            super(["Scheduled"], ScheduledMetadataTag);
        }

        /**
		 * Executed when a new [Scheduled] metadata tag is found
		 */
		override public function setUpMetadataTag( metadataTag:IMetadataTag, bean:Bean ):void
		{
			var scheduled:ScheduledMetadataTag = ScheduledMetadataTag( metadataTag );
			var method:Function = bean.source[ metadataTag.host.name ] as Function;

            setupTimer(scheduled,method);

		}

		/**
		 * Executed when a [Scheduled] metadata tag has been removed
		 */
		override public function tearDownMetadataTag(metadataTag:IMetadataTag, bean:Bean):void
		{
			var scheduled:ScheduledMetadataTag = ScheduledMetadataTag( metadataTag );
			var method:Function = bean.source[ metadataTag.host.name ] as Function;

            removeTimer(scheduled,method);

		}

        protected function setupTimer(scheduled:ScheduledMetadataTag,method:Function):void{
            var timer:Timer = new Timer(scheduled.delay,scheduled.repeatCount);
            var timerMetadata:TimerMetadata = new TimerMetadata();
            timer.addEventListener(TimerEvent.TIMER,handleTimer);
            timer.start();
            timerMetadata.callback=method;
            timerMetadata.tag=scheduled;
            timerMetadata.timer=timer;
            this._timers[scheduled.host.name]=timerMetadata;
        }

        protected function removeTimer(scheduled:ScheduledMetadataTag,method:Function):void{
            for each (var o:TimerMetadata in _timers){
                if(scheduled.host.name==o.tag.name){
                    if(o.timer.currentCount==o.tag.repeatCount){
                        stopAndRemoveTimer(o);
                    }
                    break;
                }
            }
        }

        protected function handleTimer(event:TimerEvent):void{
            var timer:Timer = event.target as Timer;

            for each (var o:TimerMetadata in _timers){
                if(timer==o.timer){
                    if(timer.currentCount==o.tag.repeatCount){
                        stopAndRemoveTimer(o);
                    }

                    var f:Function = o.callback as Function;
                    f.call();
                    break;
                }
            }
        }

        private function stopAndRemoveTimer(timerMetadata:TimerMetadata):void{
            timerMetadata.timer.stop();
            timerMetadata.timer.removeEventListener(TimerEvent.TIMER,handleTimer);
            timerMetadata.timer=null;
            delete _timers[timerMetadata.tag.host.name];            
        }


    }
}

import flash.utils.Timer;

import org.swizframework.metadata.ScheduledMetadataTag;

class TimerMetadata{

    public var tag:ScheduledMetadataTag;
    public var timer:Timer;
    public var callback:Function;

}