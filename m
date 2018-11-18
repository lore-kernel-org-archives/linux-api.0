From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 08:03:15 -0800
Message-ID: <CAKOZuet2E8fwwx1kQftjCGJ2w5T4LS38yfr1kbMUK_PG3ffNHg@mail.gmail.com>
References: <20181118111751.6142-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181118111751.6142-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 3:17 AM, Christian Brauner <christian@brauner.io> wrote:
> +static int proc_tgid_open(struct inode *inode, struct file *file)
> +{
> +       /* grab reference to struct pid */
> +       file->private_data = get_pid(proc_pid(inode));

Why grab another reference to the struct pid when the inode already has one?
