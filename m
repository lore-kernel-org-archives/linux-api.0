From: Roman Penyaev <rpenyaev@suse.de>
Subject: Re: [PATCH 1/1] eventfd new tag EFD_VPOLL: generate epoll events
Date: Fri, 31 May 2019 11:34:08 +0200
Message-ID: <480f1bda66b67f740f5da89189bbfca3@suse.de>
References: <20190526142521.GA21842@cs.unibo.it>
 <20190527073332.GA13782@kroah.com> <20190527133621.GC26073@cs.unibo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190527133621.GC26073@cs.unibo.it>
Sender: linux-kernel-owner@vger.kernel.org
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: Greg KH <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Davide Libenzi <davidel@xmailserver.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel-owner@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Renzo,

On 2019-05-27 15:36, Renzo Davoli wrote:
> On Mon, May 27, 2019 at 09:33:32AM +0200, Greg KH wrote:
>> On Sun, May 26, 2019 at 04:25:21PM +0200, Renzo Davoli wrote:
>> > This patch implements an extension of eventfd to define file descriptors
>> > whose I/O events can be generated at user level. These file descriptors
>> > trigger notifications for [p]select/[p]poll/epoll.
>> >
>> > This feature is useful for user-level implementations of network stacks
>> > or virtual device drivers as libraries.
>> 
>> How can this be used to create a "virtual device driver"?  Do you have
>> any examples of this new interface being used anywhere?
> 
> Networking programs use system calls implementing the Berkeley sockets 
> API:
> socket, accept, connect, listen, recv*, send* etc.  Programs dealing 
> with a
> device use system calls like open, read, write, ioctl etc.
> 
> When somebody wants to write a library able to behave like a network 
> stack (say
> lwipv6, picotcp) or a device, they can implement functions like 
> my_socket,
> my_accept, my_open or my_ioctl, as drop-in replacement of their system
> call counterpart.  (It is also possible to use dynamic library magic to
> rename/divert the system call requests to use their 'virtual'
> implementation provided by the library: socket maps to my_socket, recv
> to my_recv etc).
> 
> In this way portability and compatibility is easier, using a well known 
> API
> instead of inventing new ones.
> 
> Unfortunately this approach cannot be applied to
> poll/select/ppoll/pselect/epoll.

If you have to override other systemcalls, what is the problem to 
override
poll family?  It will add, let's say, 50 extra code lines complexity to 
your
userspace code.  All you need is to be woken up by *any* event and check
one mask variable, in order to understand what you need to do: read or 
write,
basically exactly what you do in your eventfd modification, but only in
userspace.


>> Why can it not be less than 64?
> This is the imeplementation of 'write'. The 64 bits include the 
> 'command'
> EFD_VPOLL_ADDEVENTS, EFD_VPOLL_DELEVENTS or EFD_VPOLL_MODEVENTS (in the 
> most
> significant 32 bits) and the set of events (in the lowest 32 bits).

Do you really need add/del/mod semantics?  Userspace still has to keep 
mask
somewhere, so you can have one simple command, which does:

    ctx->count = events;

in kernel, so no masks and this games with bits are needed.  That will
simplify API.

--
Roman
