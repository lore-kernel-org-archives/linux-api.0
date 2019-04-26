From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH V3] mm: Allow userland to request that the kernel clear
 memory on release
Date: Fri, 26 Apr 2019 09:45:11 +0200
Message-ID: <d058d1ef-994f-ea6b-b6b4-bcd838a9fe2f@suse.cz>
References: <CACdnJuup-y1xAO93wr+nr6ARacxJ9YXgaceQK9TLktE7shab1w@mail.gmail.com>
 <20190425225828.212472-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425225828.212472-1-matthewgarrett@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <mjg59@google.com>
List-Id: linux-api@vger.kernel.org

On 4/26/19 12:58 AM, Matthew Garrett wrote:
> From: Matthew Garrett <mjg59@google.com>
> 
> Applications that hold secrets and wish to avoid them leaking can use
> mlock() to prevent the page from being pushed out to swap and
> MADV_DONTDUMP to prevent it from being included in core dumps. Applications
> can also use atexit() handlers to overwrite secrets on application exit.
> However, if an attacker can reboot the system into another OS, they can
> dump the contents of RAM and extract secrets. We can avoid this by setting
> CONFIG_RESET_ATTACK_MITIGATION on UEFI systems in order to request that the
> firmware wipe the contents of RAM before booting another OS, but this means
> rebooting takes a *long* time - the expected behaviour is for a clean
> shutdown to remove the request after scrubbing secrets from RAM in order to
> avoid this.
> 
> Unfortunately, if an application exits uncleanly, its secrets may still be
> present in RAM. This can't be easily fixed in userland (eg, if the OOM
> killer decides to kill a process holding secrets, we're not going to be able
> to avoid that), so this patch adds a new flag to madvise() to allow userland
> to request that the kernel clear the covered pages whenever the page
> map count hits zero. Since vm_flags is already full on 32-bit, it
> will only work on 64-bit systems. This is currently only permitted on
> private mappings that have not yet been populated in order to simplify
> implementation, which should suffice for the envisaged use cases. We can
> extend the behaviour later if we come up with a robust set of semantics.
> 
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> ---
> 
> Updated based on feedback from Jann - for now let's just prevent setting
> the flag on anything that has already mapped some pages, which avoids
> child processes being able to interfere with the parent. In addition,

That makes the API quite tricky and different from existing madvise()
modes that don't care. One would for example have to call
madvise(MADV_WIPEONRELEASE) before mlock(), otherwise mlock() would
fault the pages in (unless MLOCK_ONFAULT). As such it really looks like
a mmap() flag, but that's less flexible.

How bout just doing the CoW on any such pre-existing pages as part of
the madvise(MADV_WIPEONRELEASE) call?
