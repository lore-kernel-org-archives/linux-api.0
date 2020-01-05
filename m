From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v8 1/3] vfs, fdtable: Add get_task_file helper
Date: Sun, 5 Jan 2020 13:47:49 +0100
Message-ID: <20200105124747.narl7otqr3d46ljp@wittgenstein>
References: <20200103162928.5271-1-sargun@sargun.me>
 <20200103162928.5271-2-sargun@sargun.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200103162928.5271-2-sargun@sargun.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, oleg@redhat.com, luto@amacapital.net, viro@zeniv.linux.org.uk, gpascutto@mozilla.com, ealvarez@mozilla.com, fweimer@redhat.com, jld@mozilla.com, arnd@arndb.de
List-Id: linux-api@vger.kernel.org

On Fri, Jan 03, 2020 at 08:29:26AM -0800, Sargun Dhillon wrote:
> This introduces a function which can be used to fetch a file, given an
> arbitrary task. As long as the user holds a reference (refcnt) to the
> task_struct it is safe to call, and will either return NULL on failure,
> or a pointer to the file, with a refcnt.
> 
> This patch is based on Oleg Nesterov's (cf. [1]) patch from September
> 2018.
> 
> [1]: Link: https://lore.kernel.org/r/20180915160423.GA31461@redhat.com
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

Nit: the patch is titled "vfs, fdtable: Add get_task_file helper"
but the actual helper is called fget_task()
