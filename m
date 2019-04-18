From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 4/5] signal: support CLONE_PIDFD with pidfd_send_signal
Date: Thu, 18 Apr 2019 16:26:00 +0200
Message-ID: <20190418142559.GA30069@redhat.com>
References: <20190418101841.4476-1-christian@brauner.io>
 <20190418101841.4476-5-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190418101841.4476-5-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On 04/18, Christian Brauner wrote:
>
> +static struct pid *pidfd_to_pid(const struct file *file)
> +{
> +	if (file->f_op == &pidfd_fops)
> +		return file->private_data;
> +
> +	return tgid_pidfd_to_pid(file);
> +}

the patch looks obviously fine to me, but I have an absolutely off-topic
question... why tgid_pidfd_to_pid() has to check d_is_dir() ?

Oleg.
