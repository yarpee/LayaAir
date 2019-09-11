package laya.ui {
	import laya.ui.Box;
	import laya.ui.IRender;
	import laya.ui.IItem;
	import laya.ui.ScrollBar;
	import laya.events.Event;
	import laya.maths.Point;
	import laya.utils.Handler;

	/*
	 * 当对象的 <code>selectedIndex</code> 属性发生变化时调度。
	 * @eventType laya.events.Event
	 */

	/*
	 * 渲染列表的单元项对象时调度。
	 * @eventType Event.RENDER
	 */

	/*
	 * <code>List</code> 控件可显示项目列表。默认为垂直方向列表。可通过UI编辑器自定义列表。
	 * @example <caption>以下示例代码，创建了一个 <code>List</code> 实例。</caption>
	 * @example (function (_super){
	 * @example import List = laya.ui.List;
	 */
	public class List extends Box implements IRender,IItem {

		/*
		 * 改变 <code>List</code> 的选择项时执行的处理器，(默认返回参数： 项索引（index:int）)。
		 */
		public var selectHandler:Handler;

		/*
		 * 单元格渲染处理器(默认返回参数cell:Box,index:int)。
		 */
		public var renderHandler:Handler;

		/*
		 * 单元格鼠标事件处理器(默认返回参数e:Event,index:int)。
		 */
		public var mouseHandler:Handler;

		/*
		 * 指定是否可以选择，若值为true则可以选择，否则不可以选择。 @default false
		 */
		public var selectEnable:Boolean;

		/*
		 * 最大分页数。
		 */
		public var totalPage:Number;

		/*
		 * @private 
		 */
		protected var _content:Box;

		/*
		 * @private 
		 */
		protected var _scrollBar:ScrollBar;

		/*
		 * @private 
		 */
		protected var _itemRender:*;

		/*
		 * @private 
		 */
		protected var _repeatX:Number;

		/*
		 * @private 
		 */
		protected var _repeatY:Number;

		/*
		 * @private 
		 */
		protected var _repeatX2:Number;

		/*
		 * @private 
		 */
		protected var _repeatY2:Number;

		/*
		 * @private 
		 */
		protected var _spaceX:Number;

		/*
		 * @private 
		 */
		protected var _spaceY:Number;

		/*
		 * @private 
		 */
		protected var _cells:Array;

		/*
		 * @private 
		 */
		protected var _array:Array;

		/*
		 * @private 
		 */
		protected var _startIndex:Number;

		/*
		 * @private 
		 */
		protected var _selectedIndex:Number;

		/*
		 * @private 
		 */
		protected var _page:Number;

		/*
		 * @private 
		 */
		protected var _isVertical:Boolean;

		/*
		 * @private 
		 */
		protected var _cellSize:Number;

		/*
		 * @private 
		 */
		protected var _cellOffset:Number;

		/*
		 * @private 
		 */
		protected var _isMoved:Boolean;

		/*
		 * 是否缓存内容，如果数据源较少，并且list内无动画，设置此属性为true能大大提高性能
		 */
		public var cacheContent:Boolean;

		/*
		 * @private 
		 */
		protected var _createdLine:Number;

		/*
		 * @private 
		 */
		protected var _cellChanged:Boolean;

		/*
		 * @private 
		 */
		protected var _offset:Point;

		/*
		 * @private 
		 */
		protected var _usedCache:String;

		/*
		 * @private 
		 */
		protected var _elasticEnabled:Boolean;

		/*
		 * @inheritDoc 
		 * @override 
		 */
		override public function destroy(destroyChild:Boolean = null):void{}

		/*
		 * @inheritDoc 
		 * @override 
		 */
		override protected function createChildren():void{}
		private var onScrollStart:*;
		private var onScrollEnd:*;

		/*
		 * 获取对 <code>List</code> 组件所包含的内容容器 <code>Box</code> 组件的引用。
		 */
		public function get content():Box{
				return null;
		}

		/*
		 * 垂直方向滚动条皮肤。
		 */
		public var vScrollBarSkin:String;
		private var _removePreScrollBar:*;

		/*
		 * 水平方向滚动条皮肤。
		 */
		public var hScrollBarSkin:String;

		/*
		 * 获取对 <code>List</code> 组件所包含的滚动条 <code>ScrollBar</code> 组件的引用。
		 */
		public var scrollBar:ScrollBar;

		/*
		 * 单元格渲染器。
		 * <p><b>取值：</b>
		 * <ol>
		 * <li>单元格类对象。</li>
		 * <li> UI 的 JSON 描述。</li>
		 * </ol></p>
		 * @implements 
		 */
		public function get itemRender():*{
				return null;
		}
		public  function set itemRender(value:*):void{}

		/*
		 * 水平方向显示的单元格数量。
		 */
		public var repeatX:Number;

		/*
		 * 垂直方向显示的单元格数量。
		 */
		public var repeatY:Number;

		/*
		 * 水平方向显示的单元格之间的间距（以像素为单位）。
		 */
		public var spaceX:Number;

		/*
		 * 垂直方向显示的单元格之间的间距（以像素为单位）。
		 */
		public var spaceY:Number;

		/*
		 * @private 更改单元格的信息。
		 */
		protected function changeCells():void{}
		private var _getOneCell:*;
		private var _createItems:*;
		protected function createItem():Box{
			return null;
		}

		/*
		 * @private 添加单元格。
		 * @param cell 需要添加的单元格对象。
		 */
		protected function addCell(cell:Box):void{}

		/*
		 * 初始化单元格信息。
		 */
		public function initItems():void{}

		/*
		 * 设置可视区域大小。
		 * <p>以（0，0，width参数，height参数）组成的矩形区域为可视区域。</p>
		 * @param width 可视区域宽度。
		 * @param height 可视区域高度。
		 */
		public function setContentSize(width:Number,height:Number):void{}

		/*
		 * @private 单元格的鼠标事件侦听处理函数。
		 */
		protected function onCellMouse(e:Event):void{}

		/*
		 * @private 改变单元格的可视状态。
		 * @param cell 单元格对象。
		 * @param visable 是否显示。
		 * @param index 单元格的属性 <code>index</code> 值。
		 */
		protected function changeCellState(cell:Box,visible:Boolean,index:Number):void{}

		/*
		 * @inheritDoc 
		 * @override 
		 */
		override protected function _sizeChanged():void{}

		/*
		 * @private 滚动条的 <code>Event.CHANGE</code> 事件侦听处理函数。
		 */
		protected function onScrollBarChange(e:Event = null):void{}
		private var posCell:*;

		/*
		 * 表示当前选择的项索引。selectedIndex值更改会引起list重新渲染
		 */
		public var selectedIndex:Number;

		/*
		 * @private 改变单元格的选择状态。
		 */
		protected function changeSelectStatus():void{}

		/*
		 * 当前选中的单元格数据源。
		 */
		public var selectedItem:*;

		/*
		 * 获取或设置当前选择的单元格对象。
		 */
		public var selection:Box;

		/*
		 * 当前显示的单元格列表的开始索引。
		 */
		public var startIndex:Number;

		/*
		 * @private 渲染单元格列表。
		 */
		protected function renderItems(from:Number = null,to:Number = null):void{}

		/*
		 * 渲染一个单元格。
		 * @param cell 需要渲染的单元格对象。
		 * @param index 单元格索引。
		 */
		protected function renderItem(cell:Box,index:Number):void{}
		private var _bindData:*;

		/*
		 * 列表数据源。
		 */
		public var array:Array;
		private var _preLen:*;

		/*
		 * 更新数据源，不刷新list，只增加滚动长度
		 * @param array 数据源
		 */
		public function updateArray(array:Array):void{}

		/*
		 * 列表的当前页码。
		 */
		public var page:Number;

		/*
		 * 列表的数据总个数。
		 */
		public function get length():Number{
				return null;
		}

		/*
		 * 单元格集合。
		 */
		public function get cells():Array{
				return null;
		}

		/*
		 * 是否开启橡皮筋效果
		 */
		public var elasticEnabled:Boolean;

		/*
		 * 刷新列表数据源。
		 */
		public function refresh():void{}

		/*
		 * 获取单元格数据源。
		 * @param index 单元格索引。
		 */
		public function getItem(index:Number):*{}

		/*
		 * 修改单元格数据源。
		 * @param index 单元格索引。
		 * @param source 单元格数据源。
		 */
		public function changeItem(index:Number,source:*):void{}

		/*
		 * 设置单元格数据源。
		 * @param index 单元格索引。
		 * @param source 单元格数据源。
		 */
		public function setItem(index:Number,source:*):void{}

		/*
		 * 添加单元格数据源。
		 * @param souce 数据源。
		 */
		public function addItem(souce:*):void{}

		/*
		 * 添加单元格数据源到对应的数据索引处。
		 * @param souce 单元格数据源。
		 * @param index 索引。
		 */
		public function addItemAt(souce:*,index:Number):void{}

		/*
		 * 通过数据源索引删除单元格数据源。
		 * @param index 需要删除的数据源索引值。
		 */
		public function deleteItem(index:Number):void{}

		/*
		 * 通过可视单元格索引，获取单元格。
		 * @param index 可视单元格索引。
		 * @return 单元格对象。
		 */
		public function getCell(index:Number):Box{
			return null;
		}

		/*
		 * <p>滚动列表，以设定的数据索引对应的单元格为当前可视列表的第一项。</p>
		 * @param index 单元格在数据列表中的索引。
		 */
		public function scrollTo(index:Number):void{}

		/*
		 * <p>缓动滚动列表，以设定的数据索引对应的单元格为当前可视列表的第一项。</p>
		 * @param index 单元格在数据列表中的索引。
		 * @param time 缓动时间。
		 * @param complete 缓动结束回掉
		 */
		public function tweenTo(index:Number,time:Number = null,complete:Handler = null):void{}

		/*
		 * @private 
		 */
		protected function _setCellChanged():void{}

		/*
		 * @override 
		 */
		override protected function commitMeasure():void{}
	}

}