From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/3] SysFS driver for QEMU fw_cfg device
Date: Wed, 19 Aug 2015 11:42:02 +0200
Message-ID: <CAKv+Gu-BOKTHb24LnemKmvCwZn0W-NOT=avY94wkkRTx2ViW=Q@mail.gmail.com>
References: <cover.1439315079.git.somlo@cmu.edu>
	<1439977109-20314-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439977109-20314-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Gabriel Somlo <somlo-D+Gtc/HYRWM@public.gmane.org>, "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jordan Justen <jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, QEMU Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, gleb-RmZWMc9puTNJc61us3aD9laTQe2KTcn/@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

(missed some cc's)

On 19 August 2015 at 11:38, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
>
> Hi Gabriel,
>
>> Several different architectures supported by QEMU are set up with a
>> "firmware configuration" (fw_cfg) device, used to pass configuration
>> "blobs" into the guest by the host running QEMU.
>>
>> Historically, these config blobs were mostly of interest to the guest
>> BIOS, but since QEMU v2.4 it is possible to insert arbitrary blobs via
>> the command line, which makes them potentially interesting to userspace
>> (e.g. for passing early boot environment variables, etc.).
>>
>
> Does 'potentially interesting' mean you have a use case? Could you elaborate?
>
>> In addition to cc-ing the people and lists indicated by get-maintainer.pl,
>> I've added a few extra lists suggested by Matt Fleming on the qemu-devel
>> list, as well as the qemu-devel list itself.
>>
>> Also cc-ing kernelnewbies, as this is my very first kenel contribution,
>> so please go easy on me for whatever silly n00b mistakes I might have still
>> missed, in spite of trying hard to do all my homework properly... :)
>>
>> The series consists of three patches:
>>
>>   1/3 - probes for the qemu fw_cfg device in locations known to work on
>>       the supported architectures, in decreasing order of "likelihood".
>>
>>       While it *may* be possible to detect the presence of fw_cfg via
>>       acpi or dtb (on x86 and arm, respectively), there's no way I know
>>       of attempting that on sun4 and ppc/mac, so I've stuck with simply
>>       probing (the fw_cfg_modes[] structure and fw_cfg_io_probe() function)
>>       in fw_cfg.c. I could use some advice on how else that could be
>>       done more elegantly, if needed.
>>
>
> Sorry, but this is really out of the question, at least on ARM, but surely on
> other architectures as well. You can't just go around and probe random memory
> addresses. Perhaps QEMU tolerates it, but on anything that resembles a real
> system, this will immediately blow up. Also, what happens if the QEMU memory
> map changes? Add more probes addresses?
>
> It is not /that/ difficult to simply wire it up to the DT and ACPI
> infrastructures, there are plenty of examples in the kernel tree how to
> accomplish that. As a bonus, it removes all the arch specific knowledge
> from your code, which means that if QEMU grows support for another DT or
> ACPI based architecture, it will just work.
>
> I am not sure how relevant sun4 and ppc/mac are for what you are trying to
> accomplish, but perhaps it would be best to focus on x86 and ARM for now
> and do it correctly. If the probing is actually needed, you can always add
> it later.
>
> --
> Ard.
>
