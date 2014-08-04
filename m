From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [REVIEW][PATCH 0/4] /proc/thread-self
Date: Mon, 04 Aug 2014 07:47:04 -0700
Message-ID: <87lhr4pb13.fsf@tassilo.jf.intel.com>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: containers@lists.osdl.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman)
writes:

> This patchset implements /proc/thread-self a magic symlink that
> solves a couple of problems.
>
> - It makes it easy to get to a specific threads directory in /proc
>   with gettid() not being exported in glibc this is currently a pain.

syscall(__NR_gettid);

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

