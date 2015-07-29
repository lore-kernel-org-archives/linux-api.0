From: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 01/11] stm class: Introduce an abstraction for System Trace Module devices
Date: Wed, 29 Jul 2015 16:25:10 +0300
Message-ID: <877fpjkseh.fsf@ashishki-desk.ger.corp.intel.com>
References: <1436177344-16751-1-git-send-email-alexander.shishkin@linux.intel.com> <1436177344-16751-2-git-send-email-alexander.shishkin@linux.intel.com> <CAAfSe-vOgnMXCy6fb8yuQ0O_5x1L1QtCmGjNjH+OtGAg6KJHrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAfSe-vOgnMXCy6fb8yuQ0O_5x1L1QtCmGjNjH+OtGAg6KJHrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chunyan Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "linux-api@vger.kernel.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Chunyan Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

>> +/**
>> + * stm_source_register_device() - register an stm_source device
>> + * @parent:    parent device
>> + * @data:      device description structure
>> + *
>> + * This will create a device of stm_source class that can write
>> + * data to an stm device once linked.
>> + *
>> + * Return:     0 on success, -errno otherwise.
>> + */
>> +int stm_source_register_device(struct device *parent,
>> +                              struct stm_source_data *data)
>> +{
>> +       struct stm_source_device *src;
>> +       int err;
>> +
>> +       if (!stm_core_up)
>> +               return -EPROBE_DEFER;
>> +
>
> I tried to update Coresight-stm driver[1] based on your this version
> patch, but the Coresight-stm driver probe() failed.
> the reason was:
> In the end of Coresight stm_probe(), we called this function, but
> "stm_core_up" was zero then, so the error returned value
> "-EPROBE_DEFER" was received.

Yes, that is the intended behavior if stm core is not initialized yet.

> In fact, "stm_core_up" would increase itself until "stm_core_init" be
> called - it's the root of this problem, I'll explain this where the
> function "stm_core_init" defined.

I'm sorry, I didn't understand this, can you rephrase?

> And redoing Coresight stm_probe() will incur a WARN_ON() like below:
>
> [    1.075746] coresight-stm 10006000.stm: stm_register_device failed
> [    1.082118] ------------[ cut here ]------------
> [    1.086819] WARNING: CPU: 1 PID: 1 at drivers/clk/clk.c:657
> clk_core_disable+0x138/0x13c()
> [    1.095353] Modules linked in:
> [    1.098487] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G S
> 4.2.0-rc1+ #107
> [    1.106398] Hardware name: Spreadtrum SC9836 Openphone Board (DT)
> [    1.112678] Call trace:
> [    1.115194] [<ffffffc00008a5b4>] dump_backtrace+0x0/0x138
> [    1.120761] [<ffffffc00008a708>] show_stack+0x1c/0x28
> [    1.125972] [<ffffffc0003320e0>] dump_stack+0x84/0xc8
> [    1.131179] [<ffffffc00009b580>] warn_slowpath_common+0xa4/0xdc
> [    1.137285] [<ffffffc00009b700>] warn_slowpath_null+0x34/0x44
> [    1.143213] [<ffffffc000321eb4>] clk_core_disable+0x134/0x13c

Well, like I said in the offline thread, this has to do with cleaning up
in the error path of stm_probe(). What happens if stm_probe() fails for
any other reason? I'm guessing the same warning.

>> +static int __init stm_core_init(void)
>> +{
>> +       int err;
>> +
>> +       err = class_register(&stm_class);
>> +       if (err)
>> +               return err;
>> +
>> +       err = class_register(&stm_source_class);
>> +       if (err)
>> +               goto err_stm;
>> +
>> +       err = stp_configfs_init();
>> +       if (err)
>> +               goto err_src;
>> +
>> +       init_srcu_struct(&stm_source_srcu);
>> +
>> +       stm_core_up++;
>> +
>> +       return 0;
>> +
>> +err_src:
>> +       class_unregister(&stm_source_class);
>> +err_stm:
>> +       class_unregister(&stm_class);
>> +
>> +       return err;
>> +}
>> +
>> +module_init(stm_core_init);
>
> Since you are using module_init() instead of postcore_initcall() which
> was in the last version patch, as such, this function would be
> executed after Coresight "stm_probe" finished.

Yes, iirc on arm the initcall order somehow forced postcore
stm_core_init() before configfs, which it relies on, causing a
crash. Now I see that somebody hacked configfs to start at core_initcall
(f5b697700c8) instead.

There has to be a way to defer stm_probe(), although a quick look at
amba code suggests it's not implemented.

> So, we think there a few optional solutions:
> 1) Remove the "stm_register_device" out from Coresight "stm_probe",
> but we have to save another global variable:
>
>     struct device *stm_dev;
>
> in the process of Coresight "stm_probe".

Sorry, didn't understand this one.

Except for I can say that having a global variable like that is a bad
idea, but that's not relevant to the problem at hand.

> 2) Change module_init() to other XYX_init() which would run prior to
> "amba_probe()" (i.e. the caller of Coresight stm_probe), this may be a
> better one.

I'm really not a big fan of the initcall games, to be honest, it will
always be a problem on some architecture or other. Having said that, if
stm_core_init() runs at postcore_initcall level, does that solve your
problem?

> 3) stm_core_init() could be turned into a library call where
> initialisation of the internals is done when first called.

Well, it's not that simple: stm is used by both stm and stm_source
devices, in this case we'll need to make sure that the first call to
either of the {stm,stm_source}_register_device() results in the actual
initialization of the stm core. I think it's a cleaner solution than the
initcall games, though.

Regards,
--
Alex
