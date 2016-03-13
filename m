From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v7 08/10] tpm: Proxy driver for supporting
 multiple emulated TPMs
Date: Sun, 13 Mar 2016 22:06:52 +0200
Message-ID: <20160313200652.GA3087@intel.com>
References: <1457751065-11507-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1457751065-11507-9-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160312185154.GA12412@intel.com>
	<201603122327.u2CNRI56031122@d01av04.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201603122327.u2CNRI56031122-YREtIfBy6dDImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Mar 12, 2016 at 06:27:13PM -0500, Stefan Berger wrote:
>    Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/12/2016
>    01:51:54 PM:
> 
>    >
>    > On Fri, Mar 11, 2016 at 09:51:03PM -0500, Stefan Berger wrote:
>    > > This patch implements a proxy driver for supporting multiple emulated
>    TPMs
>    > > in a system.
>    > >
>    > > The driver implements a device /dev/vtpmx that is used to created
>    > > a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side
>    that
>    > > is accessed using a file descriptor returned by an ioctl.
>    > > The device /dev/tpmX is the usual TPM device created by the core TPM
>    > > driver. Applications or kernel subsystems can send TPM commands to it
>    > > and the corresponding server-side file descriptor receives these
>    > > commands and delivers them to an emulated TPM.
>    >
>    > With my test script [1] running on QEMU and TPM 2.0 simulator running on
>    the
>    > host side I get this:
>    >
>    > $ python tpm2-simulator-vtpm --host=10.0.2.2
>    > cmd
>    > 80 01 00 00 00 0c 00 00 01 44 00 00
>    > rsp
>    > 80 01 00 00 00 0a 00 00 00 00
>    > Traceback (most recent call last):
>    >   File "tpm2-simulator-vtpm", line 85, in <module>
>    >     main()
>    >   File "tpm2-simulator-vtpm", line 80, in main
>    >     resp = client.send_cmd(stream)
>    >   File "/home/tpmdd/tpm2-scripts/tpm2.py", line 454, in send_cmd
>    >     rsp = self.simulator.send_cmd(cmd)
>    >   File "/home/tpmdd/tpm2-scripts/tpm2.py", line 436, in send_cmd
>    >     raise SimulatorError("Empty response")
>    > tpm2.SimulatorError: Empty response
>    >
>    > However, the process does not exit before the read call expires:
>    >
>    > $ python tpm2-list-handles
>    > Traceback (most recent call last):
>    >   File "tpm2-list-handles", line 61, in <module>
>    >     main()
>    >   File "tpm2-list-handles", line 51, in main
>    >     handles += client.get_cap(tpm2.TPM2_CAP_HANDLES,
>    tpm2.HR_LOADED_SESSION)
>    >   File "/home/tpmdd/tpm2-scripts/tpm2.py", line 782, in get_cap
>    >     next_handles, more_data = self.__get_cap_cnt(cap, pt, 1)
>    >   File "/home/tpmdd/tpm2-scripts/tpm2.py", line 766, in __get_cap_cnt
>    >     rsp = self.send_cmd(cmd)[10:]
>    >   File "/home/tpmdd/tpm2-scripts/tpm2.py", line 458, in send_cmd
>    >     rsp = f.read()
>    > IOError: [Errno 62] Timer expired
>    >
>    > The server side stays stuck unti this happens.
> 
>    This fix should solve the problem:
> 
>    diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c
>    b/drivers/char/tpm/tpm_vtpm_proxy.c
>    index d73944e..01e5070 100644
>    --- a/drivers/char/tpm/tpm_vtpm_proxy.c
>    +++ b/drivers/char/tpm/tpm_vtpm_proxy.c
>    @@ -456,10 +456,10 @@ err_delete_proxy_dev:
>      */
>     static void vtpm_proxy_delete_device(struct proxy_dev *proxy_dev)
>     {
>    -       tpm_chip_unregister(proxy_dev->chip);
>    -
>            vtpm_proxy_fops_undo_open(proxy_dev);
> 
>    +      tpm_chip_unregister(proxy_dev->chip);
>    +
>            vtpm_proxy_delete_proxy_dev(proxy_dev);
>     }
> 
>    Can you let me know whether this gets it working for you? I'd prepare a
>    v9.

So is the deadlock such that:

* tpm_chip_unregister() tries to write lock ops_sem.
* tpm_transmit() holds read lock to ops_sem.

This takes two minutes if no timeouts are calculated.

And is the effect of moving vtpm_proxy_fops_undo_open() upwards such
that vtpm_proxy_tpm_req_canceled() starts returning true, which in
effect breaks the loop in tpm_transmit()?

Yeah, the fix as a code change is very simple but I had to use perf
probe to verify this so maybe a comment there would be in place to
tell why tpm_chip_unregister() must be called last (write lock).

>       Stefan

/Jarkko

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
