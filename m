From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC PATCH ghak32 V2 01/13] audit: add container id
Date: Wed, 28 Mar 2018 12:39:12 -0600
Message-ID: <20180328123912.49b11c98@lwn.net>
References: <cover.1521179281.git.rgb@redhat.com>
        <e284617ad667ad8f17958dd8babb87fe1b4d7205.1521179281.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e284617ad667ad8f17958dd8babb87fe1b4d7205.1521179281.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, madzcar@gmail.com
List-Id: linux-api@vger.kernel.org

On Fri, 16 Mar 2018 05:00:28 -0400
Richard Guy Briggs <rgb@redhat.com> wrote:

> Implement the proc fs write to set the audit container ID of a process,
> emitting an AUDIT_CONTAINER record to document the event.

A little detail, but still...

> +static int audit_set_containerid_perm(struct task_struct *task, u64 containerid)
> +{
> +	struct task_struct *parent;
> +	u64 pcontainerid, ccontainerid;
> +
> +	/* Don't allow to set our own containerid */
> +	if (current == task)
> +		return -EPERM;
> +	/* Don't allow the containerid to be unset */
> +	if (!cid_valid(containerid))
> +		return -EINVAL;

I went looking for cid_valid(), but it turns out you don't add it until
patch 5.  That, I expect, will not be good for bisectability (or patch
review).

Thanks,

jon
