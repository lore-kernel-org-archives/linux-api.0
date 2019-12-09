From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v2 4/4] samples: Add example of using PTRACE_GETFD in conjunction with user trap
Date: Mon, 09 Dec 2019 20:49:30 +0100
Message-ID: <BE3E056F-0147-4A00-8FF7-6CC9DE02A30C@ubuntu.com>
References: <20191209070646.GA32477@ircssh-2.c.rugged-nimbus-611.internal> <20191209192959.GB10721@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191209192959.GB10721@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>, Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, luto@amacapital.net, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On December 9, 2019 8:30:00 PM GMT+01:00, Oleg Nesterov <oleg@redhat.com> wrote:
>On 12/09, Sargun Dhillon wrote:
>>
>> +#define CHILD_PORT_TRY_BIND	80
>> +#define CHILD_PORT_ACTUAL_BIND	4998
>
>...
>
>> +static int handle_req(int listener)
>> +{
>> +	struct sockaddr_in addr = {
>> +		.sin_family	= AF_INET,
>> +		.sin_port	= htons(4998),
>
>then I think
>		.sin_port = htons(CHILD_PORT_ACTUAL_BIND);
>
>would be more clear...
>
>> +		.sin_addr	= {
>> +			.s_addr	= htonl(INADDR_LOOPBACK)
>> +		}
>> +	};
>> +	struct ptrace_getfd_args getfd_args = {
>> +		.options = PTRACE_GETFD_O_CLOEXEC
>> +	};
>> +	struct seccomp_notif_sizes sizes;
>> +	struct seccomp_notif_resp *resp;
>> +	struct seccomp_notif *req;
>> +	int fd, ret = 1;
>> +
>> +	if (seccomp(SECCOMP_GET_NOTIF_SIZES, 0, &sizes) < 0) {
>> +		perror("seccomp(GET_NOTIF_SIZES)");
>> +		goto out;
>> +	}
>> +	req = malloc(sizes.seccomp_notif);
>> +	if (!req)
>> +		goto out;
>> +	memset(req, 0, sizeof(*req));
>> +
>> +	resp = malloc(sizes.seccomp_notif_resp);
>> +	if (!resp)
>> +		goto out_free_req;
>> +	memset(resp, 0, sizeof(*resp));
>> +
>> +	if (ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, req)) {
>> +		perror("ioctl recv");
>> +		goto out;
>> +	}
>> +	printf("Child tried to call bind with fd: %lld\n",
>req->data.args[0]);
>> +	getfd_args.fd = req->data.args[0];
>> +	fd = ptrace_getfd(req->pid, &getfd_args);
>
>and iiuc otherwise you do not need to ptrace the child. So you could
>remove
>ptrace(PTRACE_SEIZE) in main() and just do
>
>	ptrace(PTRACE_SEIZE, req->pid);
>	fd = ptrace_getfd(req->pid, &getfd_args);
>	ptrace(PTRACE_DETACH, req->pid);
>
>here. However, PTRACE_DETACH won't work, it needs the stopped tracee.
>We can
>add PTRACE_DETACH_ASYNC, but this makes me think that PTRACE_GETFD has
>nothing
>to do with ptrace.
>
>May be a new syscall which does ptrace_may_access() + get_task_file()
>will make
>more sense?
>
>Oleg.

Once more since this annoying app uses html by default...

But we can already do this right now and this is just an improvement.
That's a bit rich for a new syscall imho...

Christian
