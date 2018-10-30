From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Tue, 30 Oct 2018 14:49:21 -0700
Message-ID: <CAGXu5jLjum=TDab67L5XdWKEmzU_5rYeLfGXB1vb2BmfZdPuHQ@mail.gmail.com>
References: <20181029224031.29809-1-tycho@tycho.ws> <20181029224031.29809-2-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029224031.29809-2-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 29, 2018 at 3:40 PM, Tycho Andersen <tycho@tycho.ws> wrote:
>     * switch to a flags based future-proofing mechanism for struct
>       seccomp_notif and seccomp_notif_resp, thus avoiding version issues
>       with structure length (Kees)
[...]
>
> +struct seccomp_notif {
> +       __u64 id;
> +       __u32 pid;
> +       __u32 flags;
> +       struct seccomp_data data;
> +};
> +
> +struct seccomp_notif_resp {
> +       __u64 id;
> +       __s64 val;
> +       __s32 error;
> +       __u32 flags;
> +};

Hrm, so, what's the plan for when struct seccomp_data changes size?
I'm realizing that it might be "too late" for userspace to discover
it's running on a newer kernel. i.e. it gets a user notification, and
discovers flags it doesn't know how to handle. Do we actually need
both flags AND a length? Designing UAPI is frustrating! :)

Do we need another ioctl to discover the seccomp_data size maybe?

-- 
Kees Cook
