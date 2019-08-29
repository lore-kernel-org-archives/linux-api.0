From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
Date: Thu, 29 Aug 2019 17:32:27 +0200
Message-ID: <ed8796f5-eaea-c87d-ddd9-9d624059e5ee@iogearbox.net>
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-2-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190829051253.1927291-2-ast@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net
Cc: davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org, netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 8/29/19 7:12 AM, Alexei Starovoitov wrote:
> Implement permissions as stated in uapi/linux/capability.h
> 
> Note that CAP_SYS_ADMIN is replaced with CAP_BPF.
> All existing applications that use BPF do not drop all caps
> and keep only CAP_SYS_ADMIN before doing bpf() syscall.
> Hence it's highly unlikely that existing code will break.
> If there will be reports of breakage then CAP_SYS_ADMIN
> would be allowed as well with "it's usage is deprecated" message
> similar to commit ee24aebffb75 ("cap_syslog: accept CAP_SYS_ADMIN for now")
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[...]
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 22066a62c8c9..f459315625ac 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -244,9 +244,9 @@ static int htab_map_alloc_check(union bpf_attr *attr)
>   	BUILD_BUG_ON(offsetof(struct htab_elem, fnode.next) !=
>   		     offsetof(struct htab_elem, hash_node.pprev));
>   
> -	if (lru && !capable(CAP_SYS_ADMIN))
> +	if (lru && !capable(CAP_BPF))
>   		/* LRU implementation is much complicated than other
> -		 * maps.  Hence, limit to CAP_SYS_ADMIN for now.
> +		 * maps.  Hence, limit to CAP_BPF.
>   		 */
>   		return -EPERM;
>   
I don't think this works, this is pretty much going to break use cases where
orchestration daemons are deployed as containers that are explicitly granted
specified cap set and right now this is CAP_SYS_ADMIN and not CAP_BPF for bpf().
The former needs to be a superset of the latter in order for this to work and
not break compatibility between kernel upgrades.

- https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-capabilities-for-a-container
- https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities

Thanks,
Daniel
