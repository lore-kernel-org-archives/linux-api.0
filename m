From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v3 4/4] samples: show race-free pidfd metadata access
Date: Fri, 19 Apr 2019 17:30:48 +0200
Message-ID: <20190419153047.GA12228@redhat.com>
References: <20190419120904.27502-1-christian@brauner.io>
 <20190419120904.27502-5-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190419120904.27502-5-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com, Jann Horn <jann@thejh.net>
List-Id: linux-api@vger.kernel.org

On 04/19, Christian Brauner wrote:
>
> +int main(int argc, char *argv[])
> +{
> +	int ret = EXIT_FAILURE;
> +	char buf[4096] = { 0 };
> +	pid_t pid;
> +	int pidfd, procfd, statusfd;

I think you need to initialize pidfd = 0 in this version ;) Otherwise,

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
