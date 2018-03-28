From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [REVIEW][PATCH 01/11] sem/security: Pass kern_ipc_perm not
 sem_array into the sem security hooks
Date: Wed, 28 Mar 2018 16:20:29 -0700
Message-ID: <20180328232029.k47nocmmahtxqmg2@linux-n805>
References: <87vadmobdw.fsf_-_@xmission.com>
 <20180323191614.32489-1-ebiederm@xmission.com>
 <bdf6ed62-b75c-1920-d5ce-ea08428d03d0@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bdf6ed62-b75c-1920-d5ce-ea08428d03d0@schaufler-ca.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Linux Containers <containers@lists.linux-foundation.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, khlebnikov@yandex-team.ru, prakash.sangappa@oracle.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, serge.hallyn@ubuntu.com, esyr@redhat.com, jannh@google.com, linux-security-module@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
List-Id: linux-api@vger.kernel.org

On Fri, 23 Mar 2018, Casey Schaufler wrote:

>A kern_ipc_perm pointer is conventionally named isp in this code.

So the ideal name would be ipcp, used in core ipc, but I have no strong
preference over isp, ipp or whatever other name is used in LSMs. The
important thing is that kern_ipc_perm should not be called sma or any
ipc specific name.

>How about instead:

Agreed.

>
>-static int smack_sem_alloc_security(struct sem_array *sma)
>+static int smack_sem_alloc_security(struct kern_ipc_perm *isp)
> {
>-	struct kern_ipc_perm *isp = &sma->sem_perm;
>

Thanks,
Davidlohr
