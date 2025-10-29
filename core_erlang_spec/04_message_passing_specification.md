# Core Erlang Message Passing Specification

## Overview

Message passing is the fundamental communication mechanism in Core Erlang and the Erlang/OTP system. This document provides comprehensive specifications and examples of interprocess message passing in Core Erlang.

## Message Passing Primitives

### Send Operation
The `!` operator sends a message to a process:
```erlang
call 'erlang':'!'
    (Pid, Message)
```

**Semantics:**
- `Pid` - Process identifier of the target process
- `Message` - Any Erlang term to be sent
- Returns the message (for chaining)
- Asynchronous (non-blocking)

### Receive Operation
The `receive` expression receives messages:
```erlang
receive
    <Pattern1> when <Guard1> -> <Body1>
    <Pattern2> when <Guard2> -> <Body2>
    ...
after <Timeout> ->
    <TimeoutBody>
end
```

**Semantics:**
- Pattern matching against messages in mailbox
- Guards provide additional filtering
- Timeout prevents indefinite blocking
- Messages are processed in FIFO order

## Core Erlang Message Passing Examples

### Example 1: Basic Message Sending and Receiving

```erlang
module 'basic_messaging' ['sender'/0, 'receiver'/0, 'module_info'/0, 'module_info'/1]
    attributes []

'sender'/0 =
    fun () ->
        let <Pid> = call 'erlang':'spawn'
            (fun () -> apply 'receiver'/0 ())
        in  do  call 'erlang':'!'
                    (Pid, {'hello', 'world'})
                do  call 'erlang':'!'
                        (Pid, {'ping', 'pong'})
                    'ok'

'receiver'/0 =
    fun () ->
        receive
            <{'hello', Name}> when 'true' ->
                do  call 'io':'format'
                        ("Received hello: ~p~n", [Name])
                    apply 'receiver'/0 ()
            <{'ping', 'pong'}> when 'true' ->
                do  call 'io':'format'
                        ("Received ping-pong~n", [])
                    apply 'receiver'/0 ()
        after 'infinity' ->
            'ok'
        end
```

### Example 2: Request-Response Pattern

```erlang
module 'request_response' ['client'/0, 'server'/0, 'module_info'/0, 'module_info'/1]
    attributes []

'client'/0 =
    fun () ->
        let <ServerPid> = call 'erlang':'spawn'
            (fun () -> apply 'server'/0 ())
        in  let <RequestId> = call 'erlang':'make_ref'
            ()
        in  do  call 'erlang':'!'
                    (ServerPid, {'request', RequestId, 'calculate', {2, 3}})
                let <Result> = receive
                    <{'response', RequestId, Result}> when 'true' ->
                        Result
                after 5000 ->
                    {'error', 'timeout'}
                end
            in  do  call 'io':'format'
                        ("Result: ~p~n", [Result])
                    'ok'

'server'/0 =
    fun () ->
        receive
            <{'request', RequestId, 'calculate', {A, B}}> when 'true' ->
                let <Result> = call 'erlang':'+'
                    (A, B)
                in  do  call 'erlang':'!'
                            (call 'erlang':'self' (), {'response', RequestId, Result})
                        apply 'server'/0 ()
        after 'infinity' ->
            'ok'
        end
```

### Example 3: Process Registry with Registration

```erlang
module 'process_registry' ['start_registry'/0, 'register'/2, 'lookup'/1, 'module_info'/0, 'module_info'/1]
    attributes []

'start_registry'/0 =
    fun () ->
        let <RegistryPid> = call 'erlang':'spawn'
            (fun () -> apply 'registry_loop'/1 (#{}))
        in  do  call 'erlang':'register'
                    ('registry', RegistryPid)
                RegistryPid

'register'/2 =
    fun (Name, Pid) ->
        let <RegistryPid> = call 'erlang':'whereis'
            ('registry')
        in  do  call 'erlang':'!'
                    (RegistryPid, {'register', Name, Pid})
                'ok'

'lookup'/1 =
    fun (Name) ->
        let <RegistryPid> = call 'erlang':'whereis'
            ('registry')
        in  do  call 'erlang':'!'
                    (RegistryPid, {'lookup', Name, call 'erlang':'self' ()})
                receive
                    <{'lookup_result', Name, Pid}> when 'true' ->
                        Pid
                after 1000 ->
                    'undefined'
                end

'registry_loop'/1 =
    fun (Registry) ->
        receive
            <{'register', Name, Pid}> when 'true' ->
                let <NewRegistry> = call 'maps':'put'
                    (Name, Pid, Registry)
                in  apply 'registry_loop'/1 (NewRegistry)
            <{'lookup', Name, FromPid}> when 'true' ->
                let <Pid> = call 'maps':'get'
                    (Name, Registry, 'undefined')
                in  do  call 'erlang':'!'
                            (FromPid, {'lookup_result', Name, Pid})
                        apply 'registry_loop'/1 (Registry)
        after 'infinity' ->
            'ok'
        end
```

### Example 4: Message Queue with Selective Receiving

```erlang
module 'selective_receive' ['producer'/0, 'consumer'/0, 'module_info'/0, 'module_info'/1]
    attributes []

'producer'/0 =
    fun () ->
        let <ConsumerPid> = call 'erlang':'spawn'
            (fun () -> apply 'consumer'/0 ())
        in  do  call 'erlang':'!'
                    (ConsumerPid, {'message', 1, 'first'})
                do  call 'erlang':'!'
                        (ConsumerPid, {'message', 2, 'second'})
                    do  call 'erlang':'!'
                            (ConsumerPid, {'control', 'stop'})
                        do  call 'erlang':'!'
                                (ConsumerPid, {'message', 3, 'third'})
                            'ok'

'consumer'/0 =
    fun () ->
        receive
            <{'message', Id, Content}> when 'true' ->
                do  call 'io':'format'
                        ("Processed message ~p: ~p~n", [Id, Content])
                    apply 'consumer'/0 ()
            <{'control', 'stop'}> when 'true' ->
                do  call 'io':'format'
                        ("Received stop signal~n", [])
                    'stopped'
        after 'infinity' ->
            'ok'
        end
```

### Example 5: Process Supervision with Links

```erlang
module 'supervisor' ['start_supervisor'/0, 'worker'/1, 'module_info'/0, 'module_info'/1]
    attributes []

'start_supervisor'/0 =
    fun () ->
        let <WorkerPid> = call 'erlang':'spawn_link'
            (fun () -> apply 'worker'/1 (0))
        in  do  call 'erlang':'!'
                    (WorkerPid, {'start'})
                apply 'supervisor_loop'/1 (WorkerPid)

'supervisor_loop'/1 =
    fun (WorkerPid) ->
        receive
            <{'EXIT', WorkerPid, Reason}> when 'true' ->
                do  call 'io':'format'
                        ("Worker died: ~p, restarting...~n", [Reason])
                    let <NewWorkerPid> = call 'erlang':'spawn_link'
                        (fun () -> apply 'worker'/1 (0))
                    in  do  call 'erlang':'!'
                                (NewWorkerPid, {'start'})
                            apply 'supervisor_loop'/1 (NewWorkerPid)
        after 'infinity' ->
            'ok'
        end

'worker'/1 =
    fun (Count) ->
        receive
            <{'start'}> when 'true' ->
                do  call 'io':'format'
                        ("Worker started, count: ~p~n", [Count])
                    apply 'worker'/1 (Count + 1)
            <{'crash'}> when 'true' ->
                call 'erlang':'exit'
                    ('worker_crashed')
            <{'stop'}> when 'true' ->
                'stopped'
        after 5000 ->
            do  call 'io':'format'
                    ("Worker timeout, count: ~p~n", [Count])
                apply 'worker'/1 (Count + 1)
        end
```

### Example 6: Distributed Message Passing

```erlang
module 'distributed_messaging' ['start_node'/0, 'remote_call'/2, 'module_info'/0, 'module_info'/1]
    attributes []

'start_node'/0 =
    fun () ->
        let <NodeName> = call 'erlang':'node'
            ()
        in  do  call 'io':'format'
                    ("Starting node: ~p~n", [NodeName])
                apply 'node_loop'/0 ()

'node_loop'/0 =
    fun () ->
        receive
            <{'ping', FromPid}> when 'true' ->
                do  call 'erlang':'!'
                        (FromPid, {'pong', call 'erlang':'self' ()})
                    apply 'node_loop'/0 ()
            <{'remote_call', Module, Function, Args, FromPid}> when 'true' ->
                let <Result> = try
                    call 'erlang':'apply'
                        (Module, Function, Args)
                of <R> ->
                    R
                catch <_T, _R> ->
                    {'error', 'remote_call_failed'}
                end
                in  do  call 'erlang':'!'
                            (FromPid, {'remote_result', Result})
                        apply 'node_loop'/0 ()
        after 'infinity' ->
            'ok'
        end

'remote_call'/2 =
    fun (Node, {Module, Function, Args}) ->
        let <RemotePid> = call 'erlang':'spawn'
            (Node, fun () -> apply 'node_loop'/0 ())
        in  do  call 'erlang':'!'
                    (RemotePid, {'remote_call', Module, Function, Args, call 'erlang':'self' ()})
                receive
                    <{'remote_result', Result}> when 'true' ->
                        Result
                after 10000 ->
                    {'error', 'timeout'}
                end
```

### Example 7: Message Broadcasting

```erlang
module 'broadcast' ['start_broadcaster'/0, 'add_subscriber'/1, 'broadcast'/1, 'module_info'/0, 'module_info'/1]
    attributes []

'start_broadcaster'/0 =
    fun () ->
        let <BroadcasterPid> = call 'erlang':'spawn'
            (fun () -> apply 'broadcaster_loop'/1 ([]))
        in  do  call 'erlang':'register'
                    ('broadcaster', BroadcasterPid)
                BroadcasterPid

'add_subscriber'/1 =
    fun (SubscriberPid) ->
        let <BroadcasterPid> = call 'erlang':'whereis'
            ('broadcaster')
        in  do  call 'erlang':'!'
                    (BroadcasterPid, {'add_subscriber', SubscriberPid})
                'ok'

'broadcast'/1 =
    fun (Message) ->
        let <BroadcasterPid> = call 'erlang':'whereis'
            ('broadcaster')
        in  do  call 'erlang':'!'
                    (BroadcasterPid, {'broadcast', Message})
                'ok'

'broadcaster_loop'/1 =
    fun (Subscribers) ->
        receive
            <{'add_subscriber', Pid}> when 'true' ->
                let <NewSubscribers> = call 'lists':'append'
                    (Subscribers, [Pid])
                in  apply 'broadcaster_loop'/1 (NewSubscribers)
            <{'broadcast', Message}> when 'true' ->
                let <_> = call 'lists':'foreach'
                    (fun (Pid) ->
                        call 'erlang':'!'
                            (Pid, {'broadcast_message', Message})
                    end, Subscribers)
                in  apply 'broadcaster_loop'/1 (Subscribers)
        after 'infinity' ->
            'ok'
        end
```

### Example 8: Message Filtering and Routing

```erlang
module 'message_router' ['start_router'/0, 'send_message'/2, 'module_info'/0, 'module_info'/1]
    attributes []

'start_router'/0 =
    fun () ->
        let <RouterPid> = call 'erlang':'spawn'
            (fun () -> apply 'router_loop'/1 (#{}))
        in  do  call 'erlang':'register'
                    ('router', RouterPid)
                RouterPid

'send_message'/2 =
    fun (Route, Message) ->
        let <RouterPid> = call 'erlang':'whereis'
            ('router')
        in  do  call 'erlang':'!'
                    (RouterPid, {'route_message', Route, Message})
                'ok'

'router_loop'/1 =
    fun (Routes) ->
        receive
            <{'add_route', Route, HandlerPid}> when 'true' ->
                let <NewRoutes> = call 'maps':'put'
                    (Route, HandlerPid, Routes)
                in  apply 'router_loop'/1 (NewRoutes)
            <{'route_message', Route, Message}> when 'true' ->
                let <HandlerPid> = call 'maps':'get'
                    (Route, Routes, 'undefined')
                in  case HandlerPid of
                    <'undefined'> when 'true' ->
                        do  call 'io':'format'
                                ("No handler for route: ~p~n", [Route])
                            apply 'router_loop'/1 (Routes)
                    <HandlerPid> when 'true' ->
                        do  call 'erlang':'!'
                                (HandlerPid, {'handle_message', Route, Message})
                            apply 'router_loop'/1 (Routes)
                end
        after 'infinity' ->
            'ok'
        end
```

## Message Passing Patterns

### 1. Synchronous Request-Response
```erlang
'sync_request'/2 =
    fun (ServerPid, Request) ->
        let <RequestId> = call 'erlang':'make_ref'
            ()
        in  do  call 'erlang':'!'
                    (ServerPid, {'request', RequestId, Request})
                receive
                    <{'response', RequestId, Response}> when 'true' ->
                        Response
                after 5000 ->
                    {'error', 'timeout'}
                end
```

### 2. Asynchronous Fire-and-Forget
```erlang
'async_send'/2 =
    fun (Pid, Message) ->
        call 'erlang':'!'
            (Pid, Message)
```

### 3. Message Acknowledgment
```erlang
'send_with_ack'/2 =
    fun (Pid, Message) ->
        let <AckRef> = call 'erlang':'make_ref'
            ()
        in  do  call 'erlang':'!'
                    (Pid, {'message', AckRef, Message})
                receive
                    <{'ack', AckRef}> when 'true' ->
                        'ok'
                after 1000 ->
                    {'error', 'no_ack'}
                end
```

### 4. Message Batching
```erlang
'batch_send'/2 =
    fun (Pid, Messages) ->
        let <BatchId> = call 'erlang':'make_ref'
            ()
        in  do  call 'lists':'foreach'
                    (fun (Msg) ->
                        call 'erlang':'!'
                            (Pid, {'batch', BatchId, Msg})
                    end, Messages)
                receive
                    <{'batch_complete', BatchId}> when 'true' ->
                        'ok'
                after 5000 ->
                    {'error', 'batch_timeout'}
                end
```

## Message Passing Semantics

### Message Ordering
- Messages between the same two processes maintain FIFO order
- Messages from different processes may arrive in any order
- Messages are queued in the receiving process's mailbox

### Message Delivery
- Messages are delivered asynchronously
- No guarantee of delivery (process may die before receiving)
- Messages are copied (no shared memory)

### Process Identification
- Process IDs are unique within a node
- Process IDs can be sent in messages
- Process IDs become invalid when process dies

### Error Handling
- Sending to non-existent process returns the message
- Receiving from dead process may receive exit signals
- Timeouts prevent indefinite blocking

## Performance Considerations

### Message Size
- Large messages are expensive to copy
- Consider using references to shared data
- Binary data is shared (not copied)

### Message Frequency
- High-frequency messages may cause mailbox overflow
- Consider batching or throttling
- Monitor mailbox size

### Process Density
- Too many processes can cause scheduling overhead
- Balance between concurrency and resource usage
- Use process pools for high-throughput scenarios

This specification provides comprehensive examples and patterns for interprocess message passing in Core Erlang, demonstrating the fundamental communication mechanisms of the Erlang/OTP system.
