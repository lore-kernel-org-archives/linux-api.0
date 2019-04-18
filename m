From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 4/5] signal: support CLONE_PIDFD with pidfd_send_signal
Date: Thu, 18 Apr 2019 17:01:00 +0200
Message-ID: <EF6F0B39-1F4A-4A8F-9C64-FB3B1E804C83@brauner.io>
References: <20190418101841.4476-1-christian@brauner.io> <20190418101841.4476-5-christian@brauner.io> <20190418142559.GA30069@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190418142559.GA30069@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On April 18, 2019 4:26:00 PM GMT+02:00, Oleg Nesterov <oleg@redhat=2Ecom> w=
rote:
>On 04/18, Christian Brauner wrote:
>>
>> +static struct pid *pidfd_to_pid(const struct file *file)
>> +{
>> +	if (file->f_op =3D=3D &pidfd_fops)
>> +		return file->private_data;
>> +
>> +	return tgid_pidfd_to_pid(file);
>> +}
>
>the patch looks obviously fine to me, but I have an absolutely
>off-topic
>question=2E=2E=2E why tgid_pidfd_to_pid() has to check d_is_dir() ?

It doesn't have too; pure paranoia=2E

Christian
