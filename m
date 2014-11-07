From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH 0/5] kdbus: add support for lsm
Date: Fri, 7 Nov 2014 10:01:20 -0800
Message-ID: <20141107180120.GA15387@kroah.com>
References: <54539AF3.6060302@samsung.com>
 <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: pmoore@redhat.com, jkosina@suse.cz, linux-api@vger.kernel.org, inux-kernel@vger.kernel.org, john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org, desrt@desrt.ca, simon.mcvittie@collabora.co.uk, daniel@zonque.org, dh.herrmann@gmail.com, casey.schaufler@intel.com, marcel@holtmann.org, tixxdz@opendz.org, javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk, linux-security-module@vger.kernel.org, lmctlx@gmail.com, r.krypa@samsung.com
List-Id: linux-api@vger.kernel.org

On Fri, Oct 31, 2014 at 05:36:32PM +0100, Karol Lewandowski wrote:
> This is set of EXPERIMENTAL patches adding lsm support to kdbus.
> (Rebased on top of v3.17.)
> 
> >From least to most invasive:
> 
>  - (1) kdbus: extend structures with security pointer for lsm
> 
>    Trivial.  Applicable as-is.
> 
>  - (2) security: export security_file_receive for modules
>    (3) kdbus: check if lsm permits installing received fds
> 
>    fd_install doesn't seem to consult LSM, these patches
>    ensure that receiving process has the right to sent fds. 
> 
>    Compile-tested only.
> 
>  - (4) security: introduce lsm hooks for kdbus
>    (5) kdbus: make use of new lsm hooks
> 
>    Set of proof-of-concept hooks discussed previously with Paul Moore.
> 
>    kdbus integration patch (5) for review, but unlikely for integration
>    at this stage.
> 
>    Likewise, compile-tested only.
> 
> 
> Karol Lewandowski (5):
>   kdbus: extend structures with security pointer for lsm
>   security: export security_file_receive for modules
>   kdbus: check if lsm permits installing received fds
>   security: introduce lsm hooks for kdbus
>   kdbus: make use of new lsm hooks

These looks reasonable to me, thanks for sending them.  They will need
to be refreshed again after this next round of changes, but it shouldn't
be that hard to do so.

thanks,

greg k-h
