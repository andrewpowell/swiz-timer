package org.swizframework.metadata {

    import org.swizframework.reflection.BaseMetadataTag;
    import org.swizframework.reflection.IMetadataTag;

    public class ScheduledMetadataTag extends BaseMetadataTag {


        protected var _delay        :Number = -1;
        protected var _repeatCount  :Number = 0;

        public function ScheduledMetadataTag() {
            super();

            defaultArgName="delay";
        }

        public function get delay():Number {
            return _delay;
        }

        public function get repeatCount():Number {
            return _repeatCount;
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