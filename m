From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [RFC PATCH V1 01/12] audit: add container id
Date: Sat, 3 Mar 2018 03:19:13 -0600
Message-ID: <20180303091913.GA13118@mail.hallyn.com>
References: <cover.1519930146.git.rgb@redhat.com>
 <2e5d93ee46feca915a101c2fc3062da674a98223.1519930146.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2e5d93ee46feca915a101c2fc3062da674a98223.1519930146.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, mszeredi@redhat.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, trondmy@primarydata.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, madzcar@gmail.com
List-Id: linux-api@vger.kernel.org

On Thu, Mar 01, 2018 at 02:41:04PM -0500, Richard Guy Briggs wrote:
...
> +static inline bool audit_containerid_set(struct task_struct *tsk)

Hi Richard,

the calls to audit_containerid_set() confused me.  Could you make it
is_audit_containerid_set() or audit_containerid_isset()?

> +{
> +	return audit_get_containerid(tsk) != INVALID_CID;
> +}
