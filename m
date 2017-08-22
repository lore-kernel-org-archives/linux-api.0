From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] virt/kvm avoids oops by adding parameter checking
Date: Tue, 22 Aug 2017 15:37:15 +0200
Message-ID: <ad18fd18-e58c-bc70-6660-e05ddbb232a9@redhat.com>
References: <20170822010909.103060-1-nixiaoming@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170822010909.103060-1-nixiaoming@huawei.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: nixiaoming <nixiaoming@huawei.com>, rkrcmar@redhat.com
Cc: kvm@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 22/08/2017 03:09, nixiaoming wrote:
> The error parameter passed through the external interface causes the system oops.
> So it is necessary to increase the parameter check for all EXPORT_SYMBOL_GPL
> 
> example:
>  void kvm_get_kvm(struct kvm *kvm)
>  {
>         refcount_inc(&kvm->users_count); /*oops if kvm == NULL */
>  }
>  EXPORT_SYMBOL_GPL(kvm_get_kvm);
> 
> Signed-off-by: nixiaoming <nixiaoming@huawei.com>

No.  It's simply a precondition that kvm != NULL in this case.

Paolo
