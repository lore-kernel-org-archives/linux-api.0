From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/3] SysFS driver for QEMU fw_cfg device
Date: Mon, 24 Aug 2015 09:56:29 +0200
Message-ID: <CAKv+Gu8UKoTVLM_MbZ1By4XaAHT0YgAWKVxhOYg=X9H6ei7MeA@mail.gmail.com>
References: <cover.1439315079.git.somlo@cmu.edu>
	<1439977109-20314-1-git-send-email-ard.biesheuvel@linaro.org>
	<CAKv+Gu-BOKTHb24LnemKmvCwZn0W-NOT=avY94wkkRTx2ViW=Q@mail.gmail.com>
	<20150819204915.GA6164@GLSMBP.INI.CMU.EDU>
	<CAKv+Gu9wr+BUDjoz9NAkLNXxViDOM_PRoZRU8sxHog-iX=yUpQ@mail.gmail.com>
	<20150821034757.GA6982@GLSMBP.INI.CMU.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150821034757.GA6982-VPZ87SnTp2qKUezXOiBB2eW1CriLhL8O@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jordan Justen <jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, QEMU Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, Gleb Natapov <gleb-RmZWMc9puTNJc61us3aD9laTQe2KTcn/@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 21 August 2015 at 05:47, Gabriel L. Somlo <somlo-D+Gtc/HYRWM@public.gmane.org> wrote:
> On Thu, Aug 20, 2015 at 07:21:48AM +0200, Ard Biesheuvel wrote:
>> On 19 August 2015 at 22:49, Gabriel L. Somlo <somlo-D+Gtc/HYRWM@public.gmane.org> wrote:
>> >> > From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
>> >> >> Several different architectures supported by QEMU are set up with a
>> >> >> "firmware configuration" (fw_cfg) device, used to pass configuration
>> >> >> "blobs" into the guest by the host running QEMU.
>> >> >>
>> >> >> Historically, these config blobs were mostly of interest to the guest
>> >> >> BIOS, but since QEMU v2.4 it is possible to insert arbitrary blobs via
>> >> >> the command line, which makes them potentially interesting to userspace
>> >> >> (e.g. for passing early boot environment variables, etc.).
>> >> >>
>> >> >
>> >> > Does 'potentially interesting' mean you have a use case? Could you elaborate?
>> >
>> > My personal one would be something like:
>> >
>> > cat > guestinfo.txt << EOT
>> >   KEY1="val1"
>> >   KEY2="val2"
>> >   ...
>> > EOT
>> >
>> > qemu-system-x86_64 ... -fw-cfg name="opt/guestinfo",file=./guestinfo.txt ...
>> >
>> > Then, from inside the guest:
>> >
>> >   . /sys/firmware/qemu_fw_cfg/by_name/opt/guestinfo/raw
>> >
>> >   do_something_with $KEY1 $KEY2
>> >   ...
>> >
>> > But I'm thinking this is only one of the many positive things one
>> > could do with the ability to access random host-supplied blobs from
>> > guest userspace :)
>> >
>>
>> 'random host-supplied blobs' sounds awfully like files in a file
>> system to me, and that is already supported by QEMU and works with any
>> guest OS unmodified. If you are in control of the command line, surely
>> you can add a -drive xxx,fat:path/to/blobs -device xxx pair that
>> simply turns up as a volume.
>
> That did come up, here's the start of original thread on the qemu mailing
> list from a while back:
>
> https://lists.gnu.org/archive/html/qemu-devel/2015-02/msg00371.html
>
> To recap, the main advantages to transfering data this way are:
>
>         1. Asynchronous
>
>            The host can simply pass data via the qemu command line, and
>            not have to care if/when the guest is ready to accept the
>            data (i.e. has made it far enough to e.g. start a guest agent)
>

How does that not apply to a file system?

>         2. Out-of-band
>
>            I don't have to take over a user-visible element such as a
>            disk drive. Same reason VSOCK (or VMWare VMCI for that matter)
>            exist and are NOT actual Ethernet/TCP-IP network interfaces :)
>

OK that makes sense. Note that I am not the one you need to convince
that this is a good idea, but I would still like to understand better
why your use case requires this. Could you explain?

-- 
Ard.
