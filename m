From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9 3/4] arch: wire up pidfd_getfd syscall
Date: Mon, 13 Jan 2020 15:59:35 +0100
Message-ID: <CAK8P3a0NO2d5oD1dMhunyrHmoa_+CeD-JsM-Yffbp+vgJwu8fA@mail.gmail.com>
References: <20200107175927.4558-1-sargun@sargun.me> <20200107175927.4558-4-sargun@sargun.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200107175927.4558-4-sargun@sargun.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Jann Horn <jannh@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Christian Brauner <christian.brauner@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Gian-Carlo Pascutto <gpascutto@mozilla.com>, =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <ealvarez@mozilla.com>, Florian Weimer <fweimer@redhat.com>, Jed Davis <jld@mozilla.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 7, 2020 at 6:59 PM Sargun Dhillon <sargun@sargun.me> wrote:
>
> This wires up the pidfd_getfd syscall for all architectures.
>
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

This all looks correct,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
