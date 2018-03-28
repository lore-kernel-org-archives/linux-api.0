From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [REVIEW][PATCH 12/11] ipc: Directly call the security hook in
 ipc_ops.associate
Date: Wed, 28 Mar 2018 16:40:01 -0700
Message-ID: <20180328234001.asfvlyjawfmklpms@linux-n805>
References: <1520875093-18174-1-git-send-email-nagarathnam.muthusamy@oracle.com>
 <87vadzqqq6.fsf@xmission.com>
 <990e88fa-ab50-9645-b031-14e1afbf7ccc@oracle.com>
 <877eqejowd.fsf@xmission.com>
 <3a46a03d-e4dd-59b6-e25f-0020be1b1dc9@oracle.com>
 <87a7v2z2qa.fsf@xmission.com>
 <87vadmobdw.fsf_-_@xmission.com>
 <877eq2m3or.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877eq2m3or.fsf_-_@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, esyr@redhat.com, jannh@google.com, khlebnikov@yandex-team.ru, linux-api@vger.kernel.org, serge.hallyn@ubuntu.com, linux-kernel@vger.kernel.org, prakash.sangappa@oracle.com, linux-security-module@vger.kernel.org, luto@kernel.org, oleg@redhat.com, akpm@linux-foundation.org, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Pavel Emelyanov <xemul@openvz.org>
List-Id: linux-api@vger.kernel.org

On Sat, 24 Mar 2018, Eric W. Biederman wrote:

>
>After the last round of cleanups the shm, sem, and msg associate
>operations just became trivial wrappers around the appropriate security
>method.  Simplify things further by just calling the security method
>directly.
>
>Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>---
> ipc/msg.c | 10 +---------
> ipc/sem.c | 10 +---------
> ipc/shm.c | 10 +---------
> 3 files changed, 3 insertions(+), 27 deletions(-)

This is nice to see.
