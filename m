From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 00/20] MIPS: KVM: Guest FPU & SIMD (MSA) support
Date: Thu, 26 Mar 2015 17:30:35 +0100
Message-ID: <5514342B.9040106@redhat.com>
References: <1427386113-30515-1-git-send-email-james.hogan@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1427386113-30515-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-doc-owner@vger.kernel.org
To: James Hogan <james.hogan@imgtec.com>, kvm@vger.kernel.org, linux-mips@linux-mips.org
Cc: Paul Burton <paul.burton@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org



On 26/03/2015 17:08, James Hogan wrote:
> This patchset primarily adds guest Floating Point Unit (FPU) and MIPS
> SIMD Architecture (MSA) support to MIPS KVM, by enabling the host
> FPU/MSA while in guest mode.
> 
> This patchset depends on Paul Burton's FP/MSA fixes patchset, which will
> make it into 4.0. I've only included the 3 patches (15, 19, 20) that
> have changed since v1, which can be found here:
> http://thread.gmane.org/gmane.linux.kernel.api/8984

Thanks, the fixes look good.

Paolo
