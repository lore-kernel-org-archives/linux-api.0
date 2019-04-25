From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH V2] mm: Allow userland to request that the kernel clear
 memory on release
Date: Thu, 25 Apr 2019 14:37:55 +0200
Message-ID: <20190425123755.GX12751@dhcp22.suse.cz>
References: <CACdnJuup-y1xAO93wr+nr6ARacxJ9YXgaceQK9TLktE7shab1w@mail.gmail.com>
 <20190424211038.204001-1-matthewgarrett@google.com>
 <20190425121410.GC1144@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190425121410.GC1144@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu 25-04-19 14:14:10, Michal Hocko wrote:
> Please cc linux-api for user visible API proposals (now done). Keep the
> rest of the email intact for reference.
> 
> On Wed 24-04-19 14:10:39, Matthew Garrett wrote:
> > From: Matthew Garrett <mjg59@google.com>
> > 
> > Applications that hold secrets and wish to avoid them leaking can use
> > mlock() to prevent the page from being pushed out to swap and
> > MADV_DONTDUMP to prevent it from being included in core dumps. Applications
> > can also use atexit() handlers to overwrite secrets on application exit.
> > However, if an attacker can reboot the system into another OS, they can
> > dump the contents of RAM and extract secrets. We can avoid this by setting
> > CONFIG_RESET_ATTACK_MITIGATION on UEFI systems in order to request that the
> > firmware wipe the contents of RAM before booting another OS, but this means
> > rebooting takes a *long* time - the expected behaviour is for a clean
> > shutdown to remove the request after scrubbing secrets from RAM in order to
> > avoid this.
> > 
> > Unfortunately, if an application exits uncleanly, its secrets may still be
> > present in RAM. This can't be easily fixed in userland (eg, if the OOM
> > killer decides to kill a process holding secrets, we're not going to be able
> > to avoid that), so this patch adds a new flag to madvise() to allow userland
> > to request that the kernel clear the covered pages whenever the page
> > reference count hits zero. Since vm_flags is already full on 32-bit, it
> > will only work on 64-bit systems.

The changelog seems stale. You are hooking into unmap path where the
reference count might be still > 0 and the page still held by somebody.
A previous email from Willy said
"
It could be the target/source of direct I/O, or userspace could have
registered it with an RDMA device, or ...

It depends on the semantics you want.  There's no legacy code to
worry about here.  I was seeing this as the equivalent of an atexit()
handler; userspace is saying "When this page is unmapped, zero it".
So it doesn't matter that somebody else might be able to reference it --
userspace could have zeroed it themselves.
"

I am not sure this is really a bullet proof argumentation but it should
definitely be part of the changelog.

Besides that you inherently assume that the user would do mlock because
you do not try to wipe the swap content. Is this intentional?

Another question would be regarding the targeted user API. There are
some attempts to make all the freed memory to be zeroed/poisoned. Are
users who would like to use this feature also be interested in using
system wide setting as well?
-- 
Michal Hocko
SUSE Labs
