From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V40 11/29] PCI: Lock down BAR access when the kernel is
 locked down
Date: Tue, 20 Aug 2019 14:04:40 -0700
Message-ID: <CACdnJutVe5O2bJZLWQL=e2msudY_i0Mq6vj9B0NautnjRqRVfg@mail.gmail.com>
References: <20190820001805.241928-1-matthewgarrett@google.com>
 <20190820001805.241928-12-matthewgarrett@google.com> <20190820194514.GC14450@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190820194514.GC14450@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>, David Howells <dhowells@redhat.com>, Kees Cook <keescook@chromium.org>, linux-pci@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 20, 2019 at 12:45 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
> Since I've acked this and it's 11/29, I've been assuming you intend
> to merge the whole series together.  But the fact that it's up to V40
> makes me wonder if you're waiting for me to merge this one.  Just let
> me know either way.

James has merged the series.
