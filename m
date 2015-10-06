From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: Re: [PATCH v3 1/4] firmware: introduce sysfs driver for QEMU's
 fw_cfg device
Date: Tue, 6 Oct 2015 14:17:03 -0400
Message-ID: <20151006181703.GG1962@HEDWIG.INI.CMU.EDU>
References: <1443914889-9619-1-git-send-email-somlo@cmu.edu>
 <1443914889-9619-2-git-send-email-somlo@cmu.edu>
 <CALCETrXdTf-85zzGYN28iGhcUMwE-h0o_GQ1XSFK-6q0AZNvgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXdTf-85zzGYN28iGhcUMwE-h0o_GQ1XSFK-6q0AZNvgw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Jordan Justen (Intel address)" <jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org Developers" <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 06, 2015 at 10:54:42AM -0700, Andy Lutomirski wrote:
> On Sat, Oct 3, 2015 at 4:28 PM, Gabriel L. Somlo <somlo-D+Gtc/HYRWM@public.gmane.org> wrote:
> > From: Gabriel Somlo <somlo-D+Gtc/HYRWM@public.gmane.org>
> >
> > Make fw_cfg entries of type "file" available via sysfs. Entries
> > are listed under /sys/firmware/qemu_fw_cfg/by_key, in folders
> > named after each entry's selector key. Filename, selector value,
> > and size read-only attributes are included for each entry. Also,
> > a "raw" attribute allows retrieval of the full binary content of
> > each entry.
> >
> > This patch also provides a documentation file outlining the
> > guest-side "hardware" interface exposed by the QEMU fw_cfg device.
> >
> 
> What's the status of "by_name"?  There's a single (presumably
> incorrect) mention of it in a comment in this patch.
> 
> I would prefer if the kernel populated by_name itself rather than
> deferring that to udev, since I'd like to use this facility in virtme,
> and I'd like to use fw_cfg very early on boot before I even start
> udev.

"by_name" is added with patch 4/4 of the series, which I kept separate
due to the "To udev or not to udev" conversation from earlier. So far
I haven't yet figured out just HOW I'd set it up in udev, but it works
already if done in the kernel :)

Thanks,
--Gabriel
