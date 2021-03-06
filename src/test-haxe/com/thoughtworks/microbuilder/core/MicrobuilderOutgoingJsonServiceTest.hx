package com.thoughtworks.microbuilder.core;

#if (!cpp) // Disable this test for C++ target because of https://github.com/misprintt/mockatoo/issues/48

import haxe.ds.Vector;
import haxe.unit.TestCase;
import jsonStream.JsonSerializer;
import jsonStream.JsonDeserializer;
import jsonStream.RawJson;
import jsonStream.JsonStream;
import jsonStream.testUtil.JsonTestCase;
import jsonStream.io.TextParser;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo;

class MicrobuilderOutgoingJsonServiceTest extends JsonTestCase {

  function testPush():Void {

    var urlPrefix = "http://fake-url.com/fake/path";

    var mockedRouteEntry = mock(IRouteConfiguration.IRouteEntry);
    mockedRouteEntry.render(cast any).returns(new IRouteConfiguration.Request("GET", "/rendered/result", Vector.fromArrayCopy([]), null, null, null));

    var mockedRouteConfiguration = mock(IRouteConfiguration);
    mockedRouteConfiguration.nameToUriTemplate("myMethod").returns(mockedRouteEntry);

    var mockService = new MockService(urlPrefix, mockedRouteConfiguration);

    var requestJson = { "myMethod": [] }
    var requestJsonStream = JsonSerializer.serializeRaw(new RawJson(requestJson));


    mockService.push(requestJsonStream);


    assertTrue(mockService.toBeCalled);
    assertEquals("http://fake-url.com/fake/path/rendered/result", mockService.url);

  }

}

class MockService extends MicrobuilderOutgoingJsonService {


  public var toBeCalled:Bool = false;
  public var url:String;

  public override function send(url:String, httpMethod:String, requestBody: String, headers, ?responseHandler:Null<Dynamic>->?Int->?String->Void) {
    toBeCalled = true;
    this.url = url;
  }
}

#end
