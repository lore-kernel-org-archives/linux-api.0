From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
Date: Thu, 5 Sep 2019 10:37:03 +0200
Message-ID: <acc09eaf-5289-9457-3ce1-f27efb6013b8@iogearbox.net>
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-2-ast@kernel.org>
 <ed8796f5-eaea-c87d-ddd9-9d624059e5ee@iogearbox.net>
 <20190829173034.up5g74onaekp53zd@ast-mbp.dhcp.thefacebook.com>
 <59ac111e-7ce7-5e00-32c9-9b55482fe701@6wind.com>
 <46df2c36-4276-33c0-626b-c51e77b3a04f@fb.com>
 <5e36a193-8ad9-77e7-e2ff-429fb521a79c@iogearbox.net>
 <99acd443-69d7-f53a-1af0-263e0b73abef@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <99acd443-69d7-f53a-1af0-263e0b73abef@fb.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>, "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>, "luto@amacapital.net" <luto@amacapital.net>, "davem@davemloft.net" <davem@davemloft.net>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 9/4/19 5:21 PM, Alexei Starovoitov wrote:
> On 9/4/19 8:16 AM, Daniel Borkmann wrote:
>> opening/creating BPF maps" error="Unable to create map
>> /run/cilium/bpffs/tc/globals/cilium_lxc: operation not permitted"
>> subsys=daemon
>> 2019-09-04T14:11:47.28178666Z level=fatal msg="Error while creating
>> daemon" error="Unable to create map
>> /run/cilium/bpffs/tc/globals/cilium_lxc: operation not permitted"
>> subsys=daemon
> 
> Ok. We have to include caps in both cap_sys_admin and cap_bpf then.
> 
>> And /same/ deployment with reverted patches, hence no CAP_BPF gets it up
>> and running again:
>>
>> # kubectl get pods --all-namespaces -o wide
> 
> Can you share what this magic commands do underneath?

What do you mean by magic commands? Latter is showing all pods in the cluster:

https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-finding-resources

I've only been using the normal kubeadm guide for setup, it's pretty straight
forward, just the kubeadm init to bootstrap and then the kubectl create for
deploying if you need to give it a spin for testing:

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#tabs-pod-install-4

> What user do they pick to start under? and what caps are granted?

The deployment is using a 'securityContext' with 'privileged: true' for the
the container spec as majority of CNIs do. My understanding is that this is
passed down to the underlying container runtime e.g. docker as one option.

Checking moby go code, it seems to exec with GetAllCapabilities which returns
all of the capabilities it is aware of, and afaics, they seem to be using
the below go library to get the hard-coded list from where obviously CAP_BPF
is unknown which might also explain the breakage I've been seeing:

https://github.com/syndtr/gocapability/blob/33e07d32887e1e06b7c025f27ce52f62c7990bc0/capability/enum_gen.go

Thanks,
Daniel
