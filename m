From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v6 08/11] tpm: Driver for supporting
 multiple emulated TPMs
Date: Thu, 10 Mar 2016 12:30:44 -0500
Message-ID: <56E1AF44.9040807@linux.vnet.ibm.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1457545170-30120-9-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160310163915.GA4863@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160310163915.GA4863-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

 > On Wed, Mar 09, 2016 at 12:39:27PM -0500, Stefan Berger wrote:
 > > This patch implements a driver for supporting multiple emulated 
TPMs in a
 > > system.
 > >
 > > The driver implements a device /dev/vtpmx that is used to created
 > > a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side 
that
 > > is accessed using a file descriptor returned by an ioctl.
 > > The device /dev/tpmX is the usual TPM device created by the core TPM
 > > driver. Applications or kernel subsystems can send TPM commands to it
 > > and the corresponding server-side file descriptor receives these
 > > commands and delivers them to an emulated TPM.
 >
 > I wrote my first test program 'tpm2-simulator-vtpm' that at the moment
 > opens /dev/vtpmx and creates a device. As next step I'm going to
 > extend this script to connect MS TPM 2.0 simulator based on the work
 > by Peter Huewe.
 >
 > It is available here:
 >
 > git://git.infradead.org/users/jjs/tpm2-scripts.git
 >
 > The first obvious thing that I observed is that the device is closed
 > when /dev/vtpmx is closed.

I don't see how closing the /dev/vtpmx file descriptor would influence 
the device pair, if that's what you are referring to with 'device'? I 
tried that with vtpmctrl.c and the device pair stays unaffected. When 
the applications terminates, the device disappears, unless the server 
side file descriptor has been passed to an external program, so that is 
expected behavior.

 >
 > Some might want to use this in a way that the created virtual device
 > is not closed when /dev/vtpmx is closed.

I don't see that happening. If you want the device pair to stay around 
after an application terminates, you have to pass the file descriptor 
returned from the ioctl to an application.

     Stefan



------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
