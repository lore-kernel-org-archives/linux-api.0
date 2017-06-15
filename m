From: Martin Fuzzey <mfuzzey@parkeon.com>
Subject: Re: [PATCH 0/4] firmware: fix fallback mechanism by ignoring SIGCHLD
Date: Thu, 15 Jun 2017 09:49:18 +0200
Message-ID: <59423BFE.3060405@parkeon.com>
References: <20170614222017.14653-1-mcgrof@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170614222017.14653-1-mcgrof@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, gregkh@linuxfoundation.org
Cc: ebiederm@xmission.com, dmitry.torokhov@gmail.com, wagi@monom.org, dwmw2@infradead.org, jewalt@lgsinnovations.com, rafal@milecki.pl, arend.vanspriel@broadcom.com, rjw@rjwysocki.net, yi1.li@linux.intel.com, atull@kernel.org, moritz.fischer@ettus.com, pmladek@suse.com, johannes.berg@intel.com, emmanuel.grumbach@intel.com, luciano.coelho@intel.com, kvalo@codeaurora.org, luto@kernel.org, torvalds@linux-foundation.org, keescook@chromium.org, takahiro.akashi@linaro.org, dhowells@redhat.com, pjones@redhat.com, hdegoede@redhat.com, alan@linux.intel.com, tytso@mit.edu, mtk.manpages@gmail.com, paul.gortmaker@windriver.com, mtosatti@redhat.com, mawilcox@microsoft.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 15/06/17 00:20, Luis R. Rodriguez wrote:
> Martin reported an issue with Android where if sysfs is used to trigger a sync
> fw load which *relies* on the fallback mechanism and a background job completes
> while the trigger is ongoing in the foreground it will immediately fail the fw
> request.  The issue can be observed in this simple test script using the
> test_firmware driver:
>
> 	set -e
> 	/etc/init.d/udev stop
> 	modprobe test_firmware
> 	DIR=/sys/devices/virtual/misc/test_firmware
> 	echo 10 >/sys/class/firmware/timeout
> 	sleep 2 &
> 	echo -n "does-not-exist-file.bin" > "$DIR"/trigger_request
>
> The background sleep triggers the SIGCHLD signal and we fail the firmware
> request on the fallback mechanism. This was due to the type of wait used which
> ...
>
> Note that although I *feared* this might implicate any use of non-killable waits
> on other system calls, such as finit_module(), initial testing confirms this to
> not be the case.  For instance replacing the echo with modprobe on a module
> which does the same on init does not present the same issues. This could be due
> to the special SA_RESTART flag case on write() as noted above and sysfs...
> however, its not perfectly clear yet to me.
>
>
The reason the problem does not occur with modprobe is that in that case 
the processes triggering the firmware load
(modprobe) and the process dying (sleep) are *siblings* rather than 
father and child.
So the modprobe process does *not* receive a SIGCHLD when its' *brother* 
dies.

echo is a shell built-in so the process triggering the firmware load 
(the shell) and the process dying (sleep) *are* father and child.

Martin
