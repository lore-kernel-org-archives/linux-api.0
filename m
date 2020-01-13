From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9 1/4] vfs, fdtable: Add fget_task helper
Date: Mon, 13 Jan 2020 16:02:31 +0100
Message-ID: <CAK8P3a1Mv2+GuV_1DKKMvmS8MzMDaheCiUvRps-h+cATHpPXJA@mail.gmail.com>
References: <20200107175927.4558-1-sargun@sargun.me> <20200107175927.4558-2-sargun@sargun.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200107175927.4558-2-sargun@sargun.me>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Jann Horn <jannh@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Christian Brauner <christian.brauner@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Gian-Carlo Pascutto <gpascutto@mozilla.com>, =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <ealvarez@mozilla.com>, Florian Weimer <fweimer@redhat.com>, Jed Davis <jld@mozilla.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 7, 2020 at 6:59 PM Sargun Dhillon <sargun@sargun.me> wrote:
>
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

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
