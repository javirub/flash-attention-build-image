import torch
from flash_attn import flash_attn_func

def main():
    # Set device
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"Using device: {device}")

    # Create sample inputs
    batch_size = 2
    seq_len = 1024
    num_heads = 16
    head_dim = 64

    # Create query, key, value tensors
    q = torch.randn(batch_size, seq_len, num_heads, head_dim, device=device, dtype=torch.float16)
    k = torch.randn(batch_size, seq_len, num_heads, head_dim, device=device, dtype=torch.float16)
    v = torch.randn(batch_size, seq_len, num_heads, head_dim, device=device, dtype=torch.float16)

    print(f"Input shapes: q={q.shape}, k={k.shape}, v={v.shape}")

    # Run FlashAttention
    print("Running FlashAttention...")
    output = flash_attn_func(q, k, v)
    
    print(f"Output shape: {output.shape}")
    print("FlashAttention completed successfully!")

if __name__ == "__main__":
    main()