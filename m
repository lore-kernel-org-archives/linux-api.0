From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [PATCH v3 04/41] virtio: memory access APIs
Date: Mon, 24 Nov 2014 13:58:43 +0100
Message-ID: <CAMuHMdWJA4aUyHo8wq=RX-+0w+PX3NtG1ZgvWgcMwKT5KYT_Tg@mail.gmail.com>
References: <1416829787-14252-1-git-send-email-mst@redhat.com>
	<1416829787-14252-5-git-send-email-mst@redhat.com>
	<CAMuHMdWiCqbaOs-oBW3QU+_d3GsH19A2Ynv9EB_eF2sTvcWy4w@mail.gmail.com>
	<20141124121503.GB14353@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141124121503.GB14353-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, rusty-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Pranavkumar Sawargaonkar <pranavkumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Anup Patel <anup.patel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Bjarke Istrup Pedersen <gurligebis-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, stephen hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 24, 2014 at 1:15 PM, Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, Nov 24, 2014 at 01:03:24PM +0100, Geert Uytterhoeven wrote:
>> On Mon, Nov 24, 2014 at 12:52 PM, Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > virtio 1.0 makes all memory structures LE, so
>> > we need APIs to conditionally do a byteswap on BE
>> > architectures.
>> >
>> > To make it easier to check code statically,
>> > add virtio specific types for multi-byte integers
>> > in memory.
>> >
>> > Add low level wrappers that do a byteswap conditionally, these will be
>> > useful e.g. for vhost.  Add high level wrappers that
>> > query device endian-ness and act accordingly.
>>
>> > diff --git a/include/linux/virtio_byteorder.h b/include/linux/virtio_byteorder.h
>> > new file mode 100644
>> > index 0000000..824ed0b
>> > --- /dev/null
>> > +++ b/include/linux/virtio_byteorder.h
>>
>> > +static inline u16 __virtio16_to_cpu(bool little_endian, __virtio16 val)
>> > +{
>> > +       if (little_endian)
>> > +               return le16_to_cpu((__force __le16)val);
>> > +       else
>> > +               return (__force u16)val;
>> > +}
>>
>> What's wrong with just using le16-to_cpu() ...
>
> le16-to_cpu() is simply wrong: virtio needs to be
> LE or native endian, depending on whether it's running
> in 0.9 or 1.0 mode.

IC, that was not clear from the description for this patch.
I thought it was dependent on BE architectures.

Nevertheless, any chance you can get rid of the "conditional"?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
