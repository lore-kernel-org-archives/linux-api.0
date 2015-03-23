From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [virtio-dev] Re: [PATCH 1/1] Add virtio-input driver.
Date: Mon, 23 Mar 2015 12:52:36 +0100
Message-ID: <550FFE84.4060001@redhat.com>
References: <1426756391-26585-1-git-send-email-kraxel@redhat.com>	
	<1426756391-26585-2-git-send-email-kraxel@redhat.com>	
	<20150319123940-mutt-send-email-mst@redhat.com>	
	<1426847327.32097.60.camel@nilsson.home.kraxel.org>	
	<20150321225356-mutt-send-email-mst@redhat.com>
	<1427097238.6365.27.camel@nilsson.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1427097238.6365.27.camel@nilsson.home.kraxel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Gerd Hoffmann <kraxel@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, open list <linux-kernel@vger.kernel.org>, ABI/API <linux-api@vger.kernel.org>, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org



On 23/03/2015 08:53, Gerd Hoffmann wrote:
>>>>> > > > > +		if (cfg & (1 << (bit % 8)))
>>>>> > > > > +			set_bit(bit, bits);
>>>> > > > 
>>>> > > > what if not set? does something clear the mask?
>>> > > 
>>> > > kzalloc?
>> > 
>> > So you are really just reading in array of bytes?
>> > All this set bit trickery is just to convert things from LE?
> Trickery?  Just checking each bit from virtio config space, then set it
> in the input layer bitmap.  It's a simple stupid loop.
> 
> Surely not the most efficient way, but hey, it's not in the hot path and
> I'm sure I'm setting the bits correctly because this uses the standard
> linux kernel bitops.

Use __set_bit though, because set_bit is an atomic operation.

Paolo

>> > At least, this needs a comment explaining what the function does,
>> > and maybe wrap it in a helper like virtio_input_bitmap_copy or
>> > virtio_bitmap_or.
> Can do that, sure.
