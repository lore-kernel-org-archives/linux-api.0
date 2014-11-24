From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 04/41] virtio: memory access APIs
Date: Mon, 24 Nov 2014 20:49:09 +0200
Message-ID: <20141124184909.GA19382@redhat.com>
References: <1416829787-14252-1-git-send-email-mst@redhat.com>
	<1416829787-14252-5-git-send-email-mst@redhat.com>
	<CAMuHMdWiCqbaOs-oBW3QU+_d3GsH19A2Ynv9EB_eF2sTvcWy4w@mail.gmail.com>
	<20141124121503.GB14353@redhat.com>
	<CAMuHMdWJA4aUyHo8wq=RX-+0w+PX3NtG1ZgvWgcMwKT5KYT_Tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <CAMuHMdWJA4aUyHo8wq=RX-+0w+PX3NtG1ZgvWgcMwKT5KYT_Tg@mail.gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>, Anup Patel <anup.patel@linaro.org>, rusty@au1.ibm.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, virtualization@lists.linux-foundation.org, Sakari Ailus <sakari.ailus@linux.intel.com>, linux-api@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Pranavkumar Sawargaonkar <pranavkumar@linaro.org>, David Miller <davem@davemloft.net>, Alexei Starovoitov <ast@plumgrid.com>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 24, 2014 at 01:58:43PM +0100, Geert Uytterhoeven wrote:
> On Mon, Nov 24, 2014 at 1:15 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Mon, Nov 24, 2014 at 01:03:24PM +0100, Geert Uytterhoeven wrote:
> >> On Mon, Nov 24, 2014 at 12:52 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> >> > virtio 1.0 makes all memory structures LE, so
> >> > we need APIs to conditionally do a byteswap on BE
> >> > architectures.
> >> >
> >> > To make it easier to check code statically,
> >> > add virtio specific types for multi-byte integers
> >> > in memory.
> >> >
> >> > Add low level wrappers that do a byteswap conditionally, these will be
> >> > useful e.g. for vhost.  Add high level wrappers that
> >> > query device endian-ness and act accordingly.
> >>
> >> > diff --git a/include/linux/virtio_byteorder.h b/include/linux/virtio_byteorder.h
> >> > new file mode 100644
> >> > index 0000000..824ed0b
> >> > --- /dev/null
> >> > +++ b/include/linux/virtio_byteorder.h
> >>
> >> > +static inline u16 __virtio16_to_cpu(bool little_endian, __virtio16 val)
> >> > +{
> >> > +       if (little_endian)
> >> > +               return le16_to_cpu((__force __le16)val);
> >> > +       else
> >> > +               return (__force u16)val;
> >> > +}
> >>
> >> What's wrong with just using le16-to_cpu() ...
> >
> > le16-to_cpu() is simply wrong: virtio needs to be
> > LE or native endian, depending on whether it's running
> > in 0.9 or 1.0 mode.
> 
> IC, that was not clear from the description for this patch.
> I thought it was dependent on BE architectures.
> 
> Nevertheless, any chance you can get rid of the "conditional"?

I don't see how - this is fundamental to any virtio device
that wants to support both 0.9 and 1.0 from the same
codebase.

> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
