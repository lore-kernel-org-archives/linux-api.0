From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V31 00/25] Add support for kernel lockdown
Date: Tue, 26 Mar 2019 11:27:16 -0700
Message-ID: <20190326182742.16950-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-api@vger.kernel.org, luto@kernel.org
List-Id: linux-api@vger.kernel.org

Updates: Based on Andy's feedback, lockdown is now a tristate and can be
made stricter at runtime. The states are "none", "integrity" and
"confidentiality". "none" results in no behavioural change, "integrity"
enables features that prevent untrusted code from being run in ring 0,
and "confidentiality" is a superset of "integrity" that also disables
features that may be used to extract secret information from the kernel
at runtime. I've also modified the bpf patch so that only the calls
documented as giving the ability to read in-kernel data are locked down,
rather than all functionality being disabled - I'm not a bpf expert so
would gladly go for further review here. Long term, it'd be preferable
to be able to tag secrets held by the kernel and grant access to
everything else, but I'm open to further feedback here. And at Greg's
request, debugfs is now largely disabled once the system is locked down.

In the general case, I'd expect distributions to opt for nothing
stricter than "integrity" - "confidentiality" seems more suitable for
more special-case scenarios.
