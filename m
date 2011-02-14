From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH, v6 1/3] cgroups: export cgroup_iter_{start,next,end}
Date: Mon, 14 Feb 2011 14:27:44 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102141421500.26192@localhost6.localdomain6>
References: <1297688787-3592-1-git-send-email-kirill@shutemov.name> <1297688787-3592-2-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1297688787-3592-2-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com, Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


Lacks any sensible explanation why and whatfor this needs to be
exported. And I really doubt that we want to export that at all.

> +EXPORT_SYMBOL_GPL(cgroup_iter_start);
> +EXPORT_SYMBOL_GPL(cgroup_iter_next);
> +EXPORT_SYMBOL_GPL(cgroup_iter_end);

Thanks,

	tglx
