package org.swizframework.metadata {

    import org.swizframework.reflection.BaseMetadataTag;
    import org.swizframework.reflection.IMetadataTag;

    public class ScheduledMetadataTag extends BaseMetadataTag {


        private var _delay        :Number = -1;

        private var _repeatCount  :Number = 0;

        public function ScheduledMetadataTag() {
            super();

            defaultArgName="delay";
        }

        public function get delay():Number {
            return _delay;
        }
		
		public function set delay(value:Number):void
		{
			_delay = value;
		}

        public function get repeatCount():Number {
            return _repeatCount;
        }
		
		public function set repeatCount(value:Number):void
		{
			_repeatCount = value;
		}

        override public function copyFrom( metadataTag:IMetadataTag ):void
		{
			super.copyFrom( metadataTag );

			if( hasArg( "delay" ) )
			{
				this._delay = parseFloat(getArg( "delay" ).value);
			}

			if( hasArg( "repeatCount" ) )
			{
				this._repeatCount = parseFloat(getArg( "repeatCount" ).value);
			}
		}
    }
}