From: Alex Elsayed <eternaleye-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [virtio-dev] Re: [PATCH] Add virtio gpu driver.
Date: Thu, 26 Mar 2015 15:49:22 -0700
Message-ID: <mf22dj$v64$6@ger.gmane.org>
References: <20150325162246-mutt-send-email-mst@redhat.com> <1427297836.23304.29.camel@nilsson.home.kraxel.org> <20150325180721-mutt-send-email-mst@redhat.com> <1427353959.9779.2.camel@nilsson.home.kraxel.org> <20150326091545-mutt-send-email-mst@redhat.com> <1427359367.9779.9.camel@nilsson.home.kraxel.org> <20150326095736-mutt-send-email-mst@redhat.com> <1427369923.9779.18.camel@nilsson.home.kraxel.org> <20150326124751-mutt-send-email-mst@redhat.com> <1427382436.8786.15.camel@nilsson.home.kraxel.org> <20150326174401-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
List-Id: linux-api@vger.kernel.org

Michael S. Tsirkin wrote:

> On Thu, Mar 26, 2015 at 04:07:16PM +0100, Gerd Hoffmann wrote:
>>   Hi,
>> 
>> > I don't know. This seems exactly like the kind of thing
>> > we had in mind when we added the virtio pci capability.
>> > For example, we have text in spec that requires drivers
>> > to skip unknown capabilities.
>> > 
>> > And yes, if bios pokes at a specific bar then we do
>> > need to list this info in the virtio spec so this makes
>> > it an issue that is virtio related.
>> 
>> Hmm, virtio-vga is a two-in-one device basically.  When virtio is
>> enabled it behaves like virtio-gpu-pci, otherwise it behaves very
>> simliar to stdvga.  So you need to know nothing about virtio to handle
>> the vga side, and I want keep it that way.
>> 
>> When no vga compatibility is needed there always is the option to just
>> use virtio-gpu-pci instead.
>> 
>> > Yes, it's not about what we put there now. It's about being able
>> > to move things about in the future without breaking guests.
>> 
>> We don't have that today for stdvga, and I still fail to see what this
>> buys us.
>> 
>> 
>> Completely different thing crossing my mind:  I think we can make
>> virtio-vga fully compatible with stdvga.  stdvga has two bars, memory
>> (#0) and mmio (#2).  We can make the mmio bar larger and place all the
>> virtio regions there.
>> 
> 
> Full compatibility with some standard sounds like a better motivation,
> yes.

I think you misunderstand; stdvga is a specific qemu device that only 
provides the VGA interface.

This proposed GPU provides both the VGA interface (the BAR in question) 
_and_ a virtio interface.

>> 
>> I think in any case I'll go split off the vga compatibility bits to a
>> different patch (and possible a separate patch series).
>> 
>> cheers,
>>   Gerd
> 
> Will you still need me to change core to claim specific memory only?
> 
> 
